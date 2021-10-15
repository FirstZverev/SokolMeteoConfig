//
//  DevicesController.swift
//  SOKOL
//
//  Created by Володя Зверев on 13.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import AdvancedPageControl

class DevicesController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DevicesDelegate {
    func alertSetupVisualEffectView(name: String, tag: Int) {
        self.tag = tag
        setAlert(name: name)
        animateIn()
    }
    var tagSelectProfile = 0
    var tag = 0
    var deviceVC = DeviceController()
    var addDeviceVC = AddDeviceViewController()
    let networkManager = NetworkManager()
    let profileSelect = ProfileSelectController()
    let viewModel: ServiceModel = ServiceModel()
    func buttonTap(tag: Int) {
        deviceVC.selectTag = tag
        navigationController?.pushViewController(deviceVC, animated: true)
    }
    func actionPushAdd(edit: Bool) {
        addDeviceVC.editBool = edit
        addDeviceVC.tag = self.tag
        addDeviceVC.tagSelectProfile = tagSelectProfile
        self.navigationController?.pushViewController(addDeviceVC, animated: true)
    }
    
    var offSet: CGFloat = 1
    var width: CGFloat = screenW
    
    fileprivate lazy var pageControl: AdvancedPageControlView = {
        let pageControl = AdvancedPageControlView()
        pageControl.drawer = WormDrawer(numberOfPages: 2, height: 55, width: screenW / 2 - 10, space: 0, raduis: 15, currentItem: 0, indicatorColor: .white, dotsColor: .clear, isBordered: false, borderColor: .clear)
        pageControl.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        pageControl.layer.shadowRadius = 3.0
        pageControl.layer.shadowOpacity = 0.3
        pageControl.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        pageControl.layer.cornerRadius = 15
        pageControl.layer.borderColor = .none
        pageControl.backgroundColor = .clear
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    lazy var alertView: SelectPush = {
        let alertView: SelectPush = SelectPush.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
       let view = UIVisualEffectView(effect: blurEffect)
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var profileButton: UIButton = {
        let profile = UIButton()
        profile.setImage(UIImage(named: "account_Image"), for: .normal)
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.addTarget(self, action: #selector(profileAction), for: .touchUpInside)
        return profile
    }()
    
    private lazy var natificationButton: UIButton = {
        let natification = UIButton()
        natification.setImage(UIImage(named: "notifications"), for: .normal)
        natification.translatesAutoresizingMaskIntoConstraints = false
        natification.addTarget(self, action: #selector(naticAction), for: .touchUpInside)
        return natification
    }()
    
    @objc func naticAction() {
        let downloadDataViewController = DownloadDataController()
        downloadDataViewController.tagSelectProfile = tagSelectProfile
        tabBarController?.navigationController?.present(downloadDataViewController, animated: true)
    }
    @objc func profileAction() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        profileSelect.pushAccount = false
        tabBarController?.navigationController?.pushViewController(profileSelect, animated: true)
    }
    
    private lazy var labelObject: UIButton = {
       let label = UIButton()
        label.setTitle("Объекты", for: .normal)
        label.setTitleColor(.black, for: .normal)
        label.showsTouchWhenHighlighted = true
        label.setTitleColor(UIColor(rgb: 0xB64894), for: .highlighted)
        label.titleLabel?.font = UIFont(name: "FuturaPT-Medium", size: screenW / 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(actionSwipingObject), for: .touchUpInside)
        return label
    }()
    private lazy var labelGroup: UIButton = {
       let label = UIButton()
        label.setTitle("Группы", for: .normal)
        label.setTitleColor(.black, for: .normal)
        label.showsTouchWhenHighlighted = true
        label.setTitleColor(UIColor(rgb: 0xB64894), for: .highlighted)
        label.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: screenW / 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(actionSwipingGroup), for: .touchUpInside)
        return label
    }()
    
    @objc func actionSwipingGroup() {
        let contentOffset = collectionView.contentOffset
        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        self.collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        labelObject.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: screenW / 22)
        labelGroup.titleLabel?.font = UIFont(name: "FuturaPT-Medium", size: screenW / 22)
    }
    @objc func actionSwipingObject() {
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        labelGroup.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: screenW / 22)
        labelObject.titleLabel?.font = UIFont(name: "FuturaPT-Medium", size: screenW / 22)

    }
    
    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        backView.hero.id = "backView"
        return backView
    }()
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("PullToRefresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self,
                                 action: #selector(refreshOptions(sender:)),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    @objc func refreshOptions(sender: UIRefreshControl) {
        print("LOLOLOLO")
        requestUpload(sender: sender)

    }
    func requestUpload(sender: UIRefreshControl?) {
        viewAlphaAlways.isHidden = false
        networkManager.networkingPostRequestListDevice { (data, error) in
            if error == "Unauthorized" {
                self.popVC()
            } else {
                DispatchQueue.main.async {
                    viewAlphaAlways.isHidden = true
                    sender?.endRefreshing()
                    self.updateItemTableView()
                }
            }
        }
    }
    func updateItemTableView() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        guard let cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ObjectViewCell else {return}
        cell.tableView.reloadData()
    }
    func popVC() {
        tabBarController?.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        requestUpload(sender: nil)
        deviceVC.removeFromParent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = false
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(viewAlphaAlways)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        deviceVC = DeviceController(collectionViewLayout: layout)
        
        let customNavigationBar = createCustomNavigationBar(title: "SOKOLMETEO",fontSize: screenW / 22)
        self.hero.isEnabled = true
        view.sv(customNavigationBar, backView)
        customNavigationBar.hero.id = "SOKOLMETEO"
        backView.addTapGesture { [self] in self.popVC() }
        collectionView.backgroundColor = .brown
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView?.backgroundColor = .clear
        collectionView?.register(ObjectViewCell.self, forCellWithReuseIdentifier: "ObjectViewCell")
        collectionView?.register(GroupsViewCell.self, forCellWithReuseIdentifier: "GroupsViewCell")
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(pageControl)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 + 80).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 + 10).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: screenW - 5).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 55).isActive = true
        view.addSubview(labelObject)
        view.addSubview(labelGroup)
        view.addSubview(profileButton)
        view.addSubview(natificationButton)
    }
    override func viewDidAppear(_ animated: Bool) {
        labelObject.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor).isActive = true
        labelObject.centerXAnchor.constraint(equalTo: pageControl.centerXAnchor, constant: -pageControl.frame.width / 4 + 2).isActive = true
        labelObject.widthAnchor.constraint(equalToConstant: screenW / 2 - 10).isActive = true
        labelObject.heightAnchor.constraint(equalToConstant: 55).isActive = true

        labelGroup.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor).isActive = true
        labelGroup.centerXAnchor.constraint(equalTo: pageControl.centerXAnchor, constant: +pageControl.frame.width / 4 - 2).isActive = true
        labelGroup.widthAnchor.constraint(equalToConstant: screenW / 2 - 10).isActive = true
        labelGroup.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        natificationButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        natificationButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        natificationButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -13).isActive = true
        natificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        
        profileButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        profileButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -13).isActive = true
        profileButton.trailingAnchor.constraint(equalTo: natificationButton.leadingAnchor,constant: -20).isActive = true


    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjectViewCell", for: indexPath) as! ObjectViewCell
            cell.delegate = self
            cell.backgroundColor = .clear
            //        cell.imageUI.image = configModelStartSwipe[indexPath.row].image
            //        cell.imageHumanUI.image = configModelStartSwipe[indexPath.row].imageHuman
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupsViewCell", for: indexPath) as! GroupsViewCell
            cell.delegate = self
            cell.backgroundColor = .clear
            return cell

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        offSet = scrollView.contentOffset.x
        width = scrollView.frame.width
        pageControl.setCurrentItem(offset: CGFloat(offSet),width: CGFloat(width))
        if pageControl.drawer.currentItem == 0 {
            labelGroup.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: screenW / 22)
            labelObject.titleLabel?.font = UIFont(name: "FuturaPT-Medium", size: screenW / 22)
        } else {
            labelObject.titleLabel?.font = UIFont(name: "FuturaPT-Light", size: screenW / 22)
            labelGroup.titleLabel?.font = UIFont(name: "FuturaPT-Medium", size: screenW / 22)
        }
    }
}
