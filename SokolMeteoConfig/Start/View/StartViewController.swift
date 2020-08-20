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

class StartViewController: UIViewController {

    var tableView: UITableView!
    var viewModel: TableViewViewModelType?
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    let devicesListVC = DevicesDUController()
    let tabBarVC = TabBarController()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        viewModel = ViewModel()
        devicesListVC.delegate = self
        let customNavigationBar = createCustomNavigationBar(title: "МЕНЮ", fontSize: screenW / 22)
        view.sv(
            customNavigationBar
        )
//        greenView.height(50).width(50).centerInContainer()
        
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
        tableView.height(screenH - (screenH / 12)).width(screenW)
        tableView.top(screenH / 12)
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
            transitionSettingsApp()
        } else if indexPath.row == 2 {
            navigationController?.pushViewController(RegisterSokolMeteoController(), animated: true)
        } else if indexPath.row == 3 {
            navigationController?.pushViewController(TabBarConfiguratorController(), animated: true)
        } else {
            navigationController?.pushViewController(MeteoDataController(), animated: true)
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
    fileprivate func transitionSearchMeteo() {
        self.generator.impactOccurred()
        navigationController?.pushViewController(DevicesDUController(), animated: true)
    }
}

extension StartViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark, topGap: screenH / 4, modalWidth: 0, cornerRadius: 20)
    }
}

extension StartViewController: MainDelegate {
    func buttonT() {
        print("PRINT")
        print("PRINT")
        print("PRINT")
        print("PRINT")
        print("PRINT")
        print("PRINT")
        print("PRINT")
        print("PRINT")
        print("PRINT")

    }
    
    
}
