//
//  GroupController.swift
//  SOKOL
//
//  Created by Володя Зверев on 17.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class GroupController : UIViewController {
    
    var tableView: UITableView!
    let generator = UIImpactFeedbackGenerator(style: .light)
    let networkingManager = NetworkManager()
    
    private lazy var objectViewSwipe: UIView = {
        let content = UIView()
        content.backgroundColor = .white
        content.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        content.layer.shadowRadius = 3.0
        content.layer.shadowOpacity = 0.3
        content.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        content.layer.cornerRadius = 15
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    var emptyList: UILabel = {
        let emptyList = UILabel()
        emptyList.text = "СПИСОК ПУСТ"
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
        backView.hero.id = "backView"
        return backView
    }()
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

//        tableView.height(screenH - (screenH / 12)).width(screenW)
//        tableView.top(screenH / 12)
        tableView.backgroundColor = .white
        tableView.addSubview(emptyList)
        tableView.hero.id = "tableView"

        self.tableView = tableView
    }
    
    fileprivate func networkAllDevice() {
        networkingManager.networkingRequest(urlString: "https://sokolmeteo.com/api/device?start=0&count=10&sortDir=asc") { (data, error) in
            guard let data = data else {
                return self.networkAllDevice()
            }
            devicesList = data
            print(devicesList)
            self.tableView.reloadData()

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        networkAllDevice()
//        networkingPostRequestListDevice(urlString: "https://sokolmeteo.com/api/device?start=0&count=10&sortDir=asc")
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
        view.sv(customNavigationBar, backView, objectViewSwipe)
        customNavigationBar.hero.id = "SOKOLMETEO"
        objectViewSwipe.hero.id = "objectViewSwipe"
        backView.addTapGesture { [self] in self.popVC() }
        emptyList.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyList.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        emptyList.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 30).isActive = true
        emptyList.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -30).isActive = true
        
        objectViewSwipe.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: +view.frame.width / 4).isActive = true
        objectViewSwipe.topAnchor.constraint(equalTo: view.topAnchor, constant: (screenH / 12 + 10)).isActive = true
        objectViewSwipe.widthAnchor.constraint(equalToConstant: 150).isActive = true
        objectViewSwipe.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeviceCell.self, forCellReuseIdentifier: "DeviceCell")
    }
    
}

extension GroupController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        cell.label.text = devicesList[indexPath.row].name
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if devicesList.count == 0 {
            emptyList.isHidden = false
        } else {
            emptyList.isHidden = true
        }
        return devicesList.count
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
        
    }
}

