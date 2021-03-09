//
//  ReportsController.swift
//  SOKOL
//
//  Created by Володя Зверев on 13.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class ReportsController : UIViewController {
    
    var tableView: UITableView!
    let generator = UIImpactFeedbackGenerator(style: .light)
    var viewModel: ServiceModel = ServiceModel()
    let selectObectVC = SelectObectController()
    var devicesList: [DataDevices] = []
    
    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.height(screenH - (screenH / 12)).width(screenW)
        tableView.top(screenH / 12)
        tableView.backgroundColor = .white
        self.tableView = tableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        var realmDevice = realm.objects(DeviceNameModel.self)
//        let a = map(realmDevice) {$0.name}
        let customNavigationBar = createCustomNavigationBar(title: "SOKOLMETEO",fontSize: screenW / 22)
        self.hero.isEnabled = true
        createTableView()
        registerCell()
        view.sv(customNavigationBar, backView)
        customNavigationBar.hero.id = "SOKOLMETEO"
        backView.addTapGesture { [self] in self.popVC() }
    }
    
    func popVC() {
        tabBarController?.selectedIndex = 0
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SecondConfigBMVDCell.self, forCellReuseIdentifier: "SecondConfigBMVDCell")
        tableView.register(TemplatesCell.self, forCellReuseIdentifier: "TemplatesCell")

    }
    
}

extension ReportsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemplatesCell", for: indexPath) as! TemplatesCell
            cell.labelName.text = viewModel.sokolTemplateName[indexPath.row]
            cell.labelPickerTo.text = "Понедельник 2 ноября 2020"
            cell.labelPickerFrom.text = "Воскрсение 8 ноября 2020"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondConfigBMVDCell", for: indexPath) as! SecondConfigBMVDCell
            cell.label.text = viewModel.sokolTemplateName[indexPath.row]
            cell.labelMac.text = viewModel.sokolTemplateInfo[indexPath.row]
            cell.imageUI.image = UIImage(named: "EllipseSokolName")
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sokolTemplateName.count
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        generator.impactOccurred()
//        UIView.animate(withDuration: 0.5) {
//            let cell  = tableView.cellForRow(at: indexPath) as? BlackBoxListCell
//            cell!.nextImage!.tintColor = UIColor(rgb: 0xBE449E)
//            cell!.label!.textColor = UIColor(rgb: 0xBE449E)
//            cell?.contentView.backgroundColor = UIColor(rgb: 0xECECEC)
//        }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.2) {
//            let cell  = tableView.cellForRow(at: indexPath) as? BlackBoxListCell
//            cell!.nextImage!.tintColor = UIColor(rgb: 0x998F99)
//            cell?.selectionStyle = .none
//            cell!.label!.textColor = .black
//            cell?.contentView.backgroundColor = .white
//        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            selectObectVC.viewModel = viewModel
            selectObectVC.delegate = self
            let navigationController = UINavigationController(rootViewController: selectObectVC)
            navigationController.navigationBar.isHidden = true
            self.present(navigationController, animated: true)
        }
    }
}

extension ReportsController: SelectObectDelegate {
    func selected() {
        tableView.reloadData()
    }
}
