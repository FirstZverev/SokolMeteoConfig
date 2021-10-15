//
//  ArchiveDataController.swift
//  SOKOL
//
//  Created by Володя Зверев on 20.04.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import UIKit
import Hero
import Stevia
import UIDrawer
import RealmSwift
import Alamofire

class ArchiveDataController: UIViewController {

    var tableView: UITableView!
    var viewModel: TableViewViewModelType?
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    let devicesListVC = ListAvailDevices()
    let tabBarVC = TabBarController()
    let accountEnterVC = AccountEnterController()
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.isUserInteractionEnabled = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.myOrientation = .portrait
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("1617009029 время : \(unixTimeStringtoStringFull(unixTime: "1617009029"))")
        view.backgroundColor = .white
        registerTableView()
        viewModel = ViewModelArchive()
        let customNavigationBar = createCustomNavigationBar(title: "АРХИВ ДАННЫХ", fontSize: screenW / 22)
        customNavigationBar.hero.id = "customNavigationBar"

        view.sv(customNavigationBar)
        backView.tintColor = .black
        
        view.addSubview(backView)
        backView.addTapGesture { [self] in self.popVC() }

    }
    func popVC() {
        navigationController?.popViewController(animated: true)
    }

    private func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
       // tableView.separatorStyle = .none
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
//        tableView.top(screenH / 12)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        self.tableView = tableView
    }
    
    override func loadView() {
        super.loadView()
        createTableView()
    }

}

extension ArchiveDataController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let navigationController = UINavigationController(rootViewController: BlackBoxListController())
            navigationController.navigationBar.isHidden = true
            self.present(navigationController, animated: true)

        } else if indexPath.row == 1 {
            let vc = SavedFilesController()
            vc.isBackBox = false
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.navigationBar.isHidden = true
            self.present(navigationController, animated: true)
        } else {
            let vc = SavedFilesController()
            vc.isBackBox = true
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.navigationBar.isHidden = true
            self.present(navigationController, animated: true)

        }
    }
}

extension ArchiveDataController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        generator.impactOccurred()
        UIView.animate(withDuration: 0.2) {
            let cell  = tableView.cellForRow(at: indexPath) as? TableViewCell
            cell!.content!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.imageUI!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.imageUI2!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.label!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.label2!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.content?.backgroundColor = UIColor(rgb: 0xF8F8FB)
            cell!.content?.layer.shadowRadius = 5.0
            cell!.content?.layer.shadowOpacity = 0.8
            cell!.content?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell  = tableView.cellForRow(at: indexPath) as? TableViewCell
            cell!.content!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell!.imageUI!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell!.imageUI2!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell!.label!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell!.label2!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell!.content?.backgroundColor = .white
            cell!.content?.layer.shadowRadius = 3.0
            cell!.content?.layer.shadowOpacity = 0.1
            cell!.content?.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)

        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.numberOfRows()) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
        cell!.selectionStyle = .none
        if indexPath.row == 0 {
            cell!.hero.id = "ConnectToMeteo"
        } else if indexPath.row == 1 {
            cell!.hero.id = "Arcive"
        } else if indexPath.row == 2 {
            cell!.hero.id = "PlatformaSokol"
        }
        if indexPath.row % 2 == 1 {
            cell?.imageUI?.isHidden = true
            cell?.label?.isHidden = true
            cell?.label2?.isHidden = false
            cell?.label2?.textAlignment = .center
            cell?.imageUI2?.isHidden = false
        } else {
            cell?.imageUI?.isHidden = false
            cell?.label?.isHidden = false
            cell?.label2?.isHidden = true
            cell?.imageUI2?.isHidden = true
        }
        cell?.imageUI?.image = UIImage(named: "firstView2")
        cell?.imageUI2?.image = UIImage(named: "firstView2")
        cell?.selectionStyle = .none
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
}

extension ArchiveDataController {
    fileprivate func transitionSettingsApp() {
        self.generator.impactOccurred()
        let viewController = MenuController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true)
    }
    func transitionSupport() {
        self.present(SupportModel.transitionSupport(), animated: true)
    }
    
    fileprivate func transitionSearchMeteo() {
        self.generator.impactOccurred()
        navigationController?.pushViewController(ListAvailDevices(), animated: true)
    }
}

extension ArchiveDataController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark, topGap: screenH / 4, modalWidth: 0, cornerRadius: 20)
    }
}
