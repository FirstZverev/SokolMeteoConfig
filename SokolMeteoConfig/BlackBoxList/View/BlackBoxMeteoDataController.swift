//
//  BlackBoxMeteo.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 20.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class BlackBoxMeteoDataController: UIViewController {
    
    var nameDeviceBlackBox: String!
    var tableView: UITableView!
    var viewModel: TableViewViewModelType?
    var timer = Timer()
    var delegate: MeteoDelegate?
    let customNavigationBar = createCustomNavigationBar(title: "",fontSize: screenW / 22)
    var indexPathCounst: IndexPath?
    
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
    fileprivate lazy var saveButton: UIImageView = {
        let saveButton = UIImageView(image: UIImage(named: "imgPushBar"))
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        return saveButton
    }()
    
    fileprivate lazy var save2Button: UIImageView = {
        let saveButton = UIImageView(image: UIImage(named: "imgSaveBar"))
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        return saveButton
    }()
    
    fileprivate lazy var save3Button: UIImageView = {
        let saveButton = UIImageView(image: UIImage(named: "imgDeleteBar"))
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        return saveButton
    }()
    
    override func loadView() {
        super.loadView()
        createTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.myOrientation = .portrait
    }
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func viewDidAppear(_ animated: Bool) {
        reload = 2
        delegate?.buttonTapMeteo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.tableView.reloadData()
        })
        timer =  Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (timer) in
            self.delegate?.buttonTapMeteo()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        reload = -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        registerTableView()
        
        viewModel = ModelViewBlackBox()
        self.hero.isEnabled = true
        customNavigationBar.hero.id = "OnlineToMeteo"


        view.sv(
            customNavigationBar
        )
        showView()
    }
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.height(screenH).width(screenW)
//        tableView.top(screenH / 12)
        tableView.backgroundColor = UIColor(rgb: 0xECAFCC)

        
        self.tableView = tableView
    }
    
    private func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(MeteoBlackBoxCell.self, forCellReuseIdentifier: "MeteoBlackBoxCell")
        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 120))
        headerView.imageView.image = UIImage(named: "headerbg")
        self.tableView.tableHeaderView = headerView
    }
    
    func showView() {
        backView.tintColor = .black
        view.addSubview(backView)
        
        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(saveButton)
        view.addSubview(save2Button)
        view.addSubview(save3Button)
        
        saveButton.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: save2Button.leadingAnchor, constant: -10).isActive = true

        save2Button.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8).isActive = true
        save2Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        save3Button.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8).isActive = true
        save3Button.leadingAnchor.constraint(equalTo: save2Button.trailingAnchor, constant: 10).isActive = true

    }
}

extension BlackBoxMeteoDataController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if indexPath.row == 4 {
        let blackBoxGraffics = BlackBoxGraffics()
        blackBoxGraffics.name = indexPath.row - 1
        blackBoxGraffics.nameDeviceBox = nameDeviceBlackBox
            navigationController?.pushViewController(blackBoxGraffics, animated: true)
//        } else if indexPath.row == 0 {
//            navigationController?.pushViewController(TabBarController(), animated: true)
//        }
    }
}

extension BlackBoxMeteoDataController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeteoBlackBoxCell", for: indexPath) as? MeteoBlackBoxCell
        cell?.selectionStyle = .none
//        cell?.imageUI?.image = UIImage(named: "imageMeteo\(indexPath.row - 1)")
        cell?.labelTwo?.text = "\(arrayMeteo[indexPath.row])"
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        if indexPath.row == 0 {
            indexPathCounst = indexPath
            cell?.clipsToBounds = true
            cell?.layer.cornerRadius = 40
            cell?.labelTwo?.textColor = .white
            cell?.saveButton?.isHidden = false
            cell?.save2Button?.isHidden = false
            cell?.save3Button?.isHidden = false

            cell?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        } else {
            cell?.layer.cornerRadius = 0
            cell?.labelTwo?.textColor = .black
            cell?.saveButton?.isHidden = true
            cell?.save2Button?.isHidden = true
            cell?.save3Button?.isHidden = true

        }
        tableViewCell.viewModel = cellViewModel

        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            let cell  = tableView.cellForRow(at: indexPath) as? MeteoBlackBoxCell
            cell!.nextImage!.tintColor = UIColor(rgb: 0xBE449E)
            cell!.label!.textColor = UIColor(rgb: 0xBE449E)
            cell?.contentView.backgroundColor = UIColor(rgb: 0xECECEC)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell  = tableView.cellForRow(at: indexPath) as? MeteoBlackBoxCell
            cell!.nextImage!.tintColor = UIColor(rgb: 0x998F99)
            cell!.label!.textColor = .black
            cell?.contentView.backgroundColor = .white
        }
    }
}

extension BlackBoxMeteoDataController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! StretchyTableHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
        
        let cell = self.tableView.cellForRow(at: indexPathCounst!) as? MeteoBlackBoxCell
        let offset = (scrollView.contentOffset.y - 92) / 3
        print(offset)
        if offset > 1 {
//            offset = 1
//            cell?.saveButton?.alpha = offset - 1
//            cell?.saveButton?.image = UIImage(named: "imgPushBar")
//            cell?.saveButton?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            if offset > 4 {
                customNavigationBar.alpha = offset - 4
            }
            saveButton.alpha = offset
            save2Button.alpha = offset
            save3Button.alpha = offset
        } else {
//            cell?.saveButton?.image = UIImage(named: "imgPush")
            if -offset / 5 + 1 >= 1.0 {
                cell?.saveButton?.transform = CGAffineTransform(scaleX: 1, y: 1)
                cell?.save2Button?.transform = CGAffineTransform(scaleX: 1, y: 1)
                cell?.save3Button?.transform = CGAffineTransform(scaleX: 1, y: 1)

//                cell?.saveButton?.alpha = -offset

            } else {
                cell?.saveButton?.transform = CGAffineTransform(scaleX: -offset / 5 + 1, y: -offset / 5 + 1)
                cell?.save2Button?.transform = CGAffineTransform(scaleX: -offset / 5 + 1, y: -offset / 5 + 1)
                cell?.save3Button?.transform = CGAffineTransform(scaleX: -offset / 5 + 1, y: -offset / 5 + 1)

//                cell?.saveButton?.alpha = -offset
            }
            customNavigationBar.alpha = 0
            saveButton.alpha = offset
            save2Button.alpha = offset
            save3Button.alpha = offset
        }
    }
}

