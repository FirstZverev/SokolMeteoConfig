//
//  ViewController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import Hero
import Stevia
import UIDrawer
import RealmSwift
import FittedSheets
import Alamofire

class StartViewController: UIViewController {

    var tableView: UITableView!
    var viewModel: TableViewViewModelType?
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    let devicesListVC = ListAvailDevices()
    let tabBarVC = TabBarController()
    
    var versionLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.frame = CGRect(x: 0, y: screenH - 40, width: screenW - 20, height: 20)
        versionLabel.font = UIFont(name:"FuturaPT-Medium", size: screenW / 22)
        versionLabel.textColor = .black
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if let version = appVersion {
            versionLabel.text = "v. \(version)"
        }
        versionLabel.textAlignment = .left
        versionLabel.center.x = screenW/2
        return versionLabel
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.isUserInteractionEnabled = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.myOrientation = .portrait
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
        view.backgroundColor = .white
        registerTableView()
        viewModel = ViewModel()
        let customNavigationBar = createCustomNavigationBar(title: "МЕНЮ", fontSize: screenW / 22)

        view.sv(customNavigationBar)
        view.addSubview(versionLabel)
        
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

extension StartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            transitionSearchMeteo()
        } else if indexPath.row == 1 {
            navigationController?.pushViewController(BlackBoxListController(), animated: true)

        } else if indexPath.row == 2 {
            navigationController?.pushViewController(AccountEnterController(), animated: true)
        } else if indexPath.row == 3 {
//            navigationController?.pushViewController(BlackBoxGraffics(), animated: true)
            transitionSupport()
        } else {
            transitionSettingsApp()
        }
    }
}

extension StartViewController: UITableViewDataSource {
    
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
        return viewModel?.numberOfRows() ?? 0
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
            cell?.imageUI2?.isHidden = false
        } else {
            cell?.imageUI?.isHidden = false
            cell?.label?.isHidden = false
            cell?.label2?.isHidden = true
            cell?.imageUI2?.isHidden = true
        }
        cell?.imageUI?.image = UIImage(named: "firstView\(indexPath.row + 1)")
        cell?.imageUI2?.image = UIImage(named: "firstView\(indexPath.row + 1)")
        cell?.selectionStyle = .none
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
}

extension StartViewController {
    fileprivate func transitionSettingsApp() {
        self.generator.impactOccurred()
        let viewController = MenuController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true)
    }
    func transitionSupport() {
        let controller = SupportController()
//        viewController.height = screenW - 50
//        viewController.topCornerRadius = 35
//        viewController.presentDuration = 0.5
//        viewController.dismissDuration = 0.2
//        viewController.modalPresentationStyle = .custom

        let sheetController = SheetViewController(
            controller: controller,
            sizes: [.percent(0.2), .fixed(screenH * 0.2), .fullscreen])
            
        // The size of the grip in the pull bar
        sheetController.gripSize = CGSize(width: 50, height: 6)

        // The color of the grip on the pull bar
        sheetController.gripColor = UIColor(white: 0.868, alpha: 1)

        // The corner radius of the sheet
        sheetController.cornerRadius = 35
            
        // minimum distance above the pull bar, prevents bar from coming right up to the edge of the screen
        sheetController.minimumSpaceAbovePullBar = screenH * 0.8

        // Set the pullbar's background explicitly
        sheetController.pullBarBackgroundColor = UIColor.white

        // Determine if the rounding should happen on the pullbar or the presented controller only (should only be true when the pull bar's background color is .clear)
        sheetController.treatPullBarAsClear = false

        // Disable the dismiss on background tap functionality
        sheetController.dismissOnOverlayTap = true

        // Disable the ability to pull down to dismiss the modal
        sheetController.dismissOnPull = true

        /// Allow pulling past the maximum height and bounce back. Defaults to true.
        sheetController.allowPullingPastMaxHeight = true

        /// Automatically grow/move the sheet to accomidate the keyboard. Defaults to true.
        sheetController.autoAdjustToKeyboard = true
        
        self.present(sheetController, animated: true)

    }
    fileprivate func transitionSearchMeteo() {
        self.generator.impactOccurred()
        navigationController?.pushViewController(ListAvailDevices(), animated: true)
    }
}

extension StartViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark, topGap: screenH / 4, modalWidth: 0, cornerRadius: 20)
    }
}
