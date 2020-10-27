//
//  SettingsBMVDController.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 20.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import AdvancedPageControl

class SettingsBMVDController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var offSet: CGFloat = 1
    var width: CGFloat = screenW
    let customNavigationBar = createCustomNavigationBar(title: "БЕСПРОВОДНОЙ МОДУЛЬ",fontSize: screenW / 22)
    var delegate: SettingsBMVDDelegate?

    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(rgb: 0xBE449E)
        view.layer.cornerRadius = 15
        view.setTitle("Далее", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.addTarget(self, action: #selector(nextTap), for: .touchUpInside)
        return view
    }()
    
    fileprivate lazy var pageControl: AdvancedPageControlView = {
        let pageControl = AdvancedPageControlView()
        pageControl.drawer = WormDrawer(numberOfPages: 6, height: 12, width: screenW / 8, space: 13, raduis: 12, currentItem: 0,indicatorColor: UIColor(rgb: 0xBE449E), dotsColor: UIColor(rgb: 0xC4C4C4), isBordered: false)
        pageControl.backgroundColor = .clear
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView?.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.addTapGesture {
            self.view.endEditing(true)
        }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView?.register(SettingsBmvdCell.self, forCellWithReuseIdentifier: "SettingsBmvdCell")
        collectionView.isPagingEnabled = true
        view.backgroundColor = .white
        view.sv(customNavigationBar)
        view.addSubview(backView)
        backView.addTapGesture { [self] in self.popVC() }

        view.addSubview(nextButton)
        view.addSubview(pageControl)
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavigationBar.bottomAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true

        pageControl.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 20).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 15).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(screenH / 40)).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2.5).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func nextTap() {
//        collectionView?.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: .right)
//        navigationController?.pushViewController(StartViewController(), animated: true
        let nextItemNext: Int = Int(pageControl.drawer.currentItem) + 1
        print(nextItemNext)
        print(pageControl.drawer.numberOfPages)
        if nextItemNext == pageControl.drawer.numberOfPages {
            UIView.animate(withDuration: 1.0, animations: { [self] in
                popVC()
            })
        } else if nextItemNext == 2 {
            let a = collectionView.cellForItem(at: IndexPath(row: nextItemNext - 1, section: 0)) as! SettingsBmvdCell
            macAddress = a.textField.text ?? ""
            reload = 9
            delegate?.buttonTapSecondConfigurator()
            collectionView.scrollToItem(at: IndexPath(row: nextItemNext, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            collectionView.scrollToItem(at: IndexPath(row: nextItemNext, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configModelSettingsBmvd.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsBmvdCell", for: indexPath) as! SettingsBmvdCell
        cell.backgroundColor = .clear
        cell.imageUI.image = configModelSettingsBmvd[indexPath.row].imageHuman
        cell.imageHumanUI.image = configModelSettingsBmvd[indexPath.row].image
        cell.label.text = configModelSettingsBmvd[indexPath.row].text
        cell.labelUpper.text = configModelSettingsBmvd[indexPath.row].textUpper
        if indexPath.row == 0 {
            cell.imageUI.isHidden = false
            cell.textField.isHidden = false
            cell.textField.isEnabled = false
            cell.textField.text = "\(KBCH)" + " канал"
            cell.labelFirst.text = """
                Выбор канала обмена с
                беспроводным модулем
                """
        } else if indexPath.row == 1 {
            cell.textField.isEnabled = true
            cell.labelFirst.text = "MAC адрес:"
            cell.textField.isHidden = false
            cell.textField.attributedPlaceholder = NSAttributedString(string: "EE EE EE EE EE EE",attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xB9B9B9)])
            cell.imageUI.isHidden = true
        } else {
            cell.textField.isEnabled = false
            cell.textField.isHidden = true
            cell.imageUI.isHidden = true
            cell.labelFirst.text = ""
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        offSet = scrollView.contentOffset.x
        width = scrollView.frame.width
        pageControl.setCurrentItem(offset: CGFloat(offSet),width: CGFloat(width))
        scrollView.endEditing(true)
    }
}
