//
//  BlackBoxListController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 29.09.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import RealmSwift

class BlackBoxListController : UIViewController {
    var realmCheck: [String]?
    var tableView: UITableView!
    var a: CGFloat = 0
    let generator = UIImpactFeedbackGenerator(style: .light)

    var emptyList: UILabel = {
        let emptyList = UILabel()
        emptyList.text = "СПИСОК ПУСТ, ЗАГРУЗИТЕ ДАННЫЕ С МЕТЕОСТАНЦИИ"
        emptyList.numberOfLines = 0
        emptyList.textAlignment = .center
//        emptyList.center.x = screenW / 2
//        emptyList.center.y = screenH / 2
        emptyList.font = UIFont(name: "FuturaPT-Light", size: screenW / 16)
        emptyList.textColor = .gray
        emptyList.translatesAutoresizingMaskIntoConstraints = false
//        emptyList.isHidden = false
        return emptyList
    }()
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
        tableView.addSubview(emptyList)
        self.tableView = tableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        var config = Realm.Configuration(
            schemaVersion: 2,
            
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 2) {
                }
            })
        config.deleteRealmIfMigrationNeeded = true

        Realm.Configuration.defaultConfiguration = config
        let realm: Realm  = {
            return try! Realm()
        }()
        
        let setArray = Set(realm.objects(BoxModel.self).value(forKey: "nameDevice") as! [String])
        realmCheck = Array(setArray)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        var realmDevice = realm.objects(DeviceNameModel.self)
//        let a = map(realmDevice) {$0.name}
        let customNavigationBar = createCustomNavigationBar(title: "АРХИВ ДАННЫХ",fontSize: screenW / 22)
        self.hero.isEnabled = true
        createTableView()
        registerCell()
        view.sv(customNavigationBar, backView)
        customNavigationBar.hero.id = "Arcive"
        backView.addTapGesture { [self] in self.popVC() }
        emptyList.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyList.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        emptyList.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 30).isActive = true
        emptyList.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -30).isActive = true

    }
    
    func popVC() {
        self.dismiss(animated: true)
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BlackBoxListCell.self, forCellReuseIdentifier: "BlackBoxListCell")
    }
    
}

extension BlackBoxListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlackBoxListCell", for: indexPath) as! BlackBoxListCell
        cell.label.text = realmCheck![indexPath.row]
        cell.imageUI.image = UIImage(named: configListBox[0].image)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if realmCheck?.count == 0 {
            emptyList.isHidden = false
        } else {
            emptyList.isHidden = true
        }
        return realmCheck?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        generator.impactOccurred()
        UIView.animate(withDuration: 0.5) {
            let cell  = tableView.cellForRow(at: indexPath) as? BlackBoxListCell
            cell!.nextImage!.tintColor = UIColor(rgb: 0xBE449E)
            cell!.label!.textColor = UIColor(rgb: 0xBE449E)
            cell?.contentView.backgroundColor = UIColor(rgb: 0xECECEC)
        }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell  = tableView.cellForRow(at: indexPath) as? BlackBoxListCell
            cell!.nextImage!.tintColor = UIColor(rgb: 0x998F99)
            cell?.selectionStyle = .none
            cell!.label!.textColor = .black
            cell?.contentView.backgroundColor = .white
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let blackBoxMeteoDataController = BlackBoxMeteoDataController()
        blackBoxMeteoDataController.nameDeviceBlackBox = realmCheck![indexPath.row]
        navigationController?.pushViewController(blackBoxMeteoDataController, animated: true)
    }
}

