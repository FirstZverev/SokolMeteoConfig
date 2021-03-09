//
//  ProfileSelectController.swift
//  SOKOL
//
//  Created by Володя Зверев on 01.02.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileSelectController : UIViewController {
    
    var tableView: UITableView!
    let generator = UIImpactFeedbackGenerator(style: .light)
    var viewModel: ServiceModel = ServiceModel()
    var delegate: SelectObectDelegate?
    var realmData: Results<AccountModel>?
    var pushAccount = true
    
    let labelMain: UILabel = {
        let labelMain = UILabel()
        labelMain.font = UIFont(name:"FuturaPT-Medium", size: screenW / 18)
        labelMain.text = "Выберете один из ваших профилей для авторизации"
        labelMain.textAlignment = .center
        labelMain.textColor = UIColor(rgb: 0xBE449E)
        labelMain.translatesAutoresizingMaskIntoConstraints = false
        labelMain.numberOfLines = 0
        return labelMain
    }()
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
//        tableView.height(screenH - (screenH / 12)).width(screenW)
//        tableView.top(screenH / 12)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        self.tableView = tableView
    }
    private lazy var closeButton: UIButton = {
        let natification = UIButton()
        natification.setImage(UIImage(named: "closePop"), for: .normal)
        natification.translatesAutoresizingMaskIntoConstraints = false
        natification.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return natification
    }()
    
    @objc func closeAction() {
        popVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
        view.sv(customNavigationBar)
        customNavigationBar.hero.id = "SOKOLMETEO"
        view.addSubview(labelMain)
        view.addSubview(closeButton)
        

        NSLayoutConstraint.activate([
            
            self.labelMain.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 + 20),
            self.labelMain.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            self.labelMain.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),

            
            self.tableView.topAnchor.constraint(equalTo: labelMain.bottomAnchor, constant: 20 ),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.bottomAnchor.constraint(equalTo: labelMain.topAnchor, constant: -25),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)


        ])
    }
    
    func popVC() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        self.navigationController?.view.layer.add(transition, forKey: nil)
        if pushAccount {
            for obj in (self.navigationController?.viewControllers)! {
                if obj is AccountEnterController {
                    let vc: AccountEnterController =  obj as! AccountEnterController
                    self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        } else {
            for obj in (self.navigationController?.viewControllers)! {
                if obj is TabBarSokolMeteoController {
                    let vc: TabBarSokolMeteoController =  obj as! TabBarSokolMeteoController
                    self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileSelectCell.self, forCellReuseIdentifier: "ProfileSelectCell")

    }
    
    
}

extension ProfileSelectController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSelectCell", for: indexPath) as! ProfileSelectCell
        cell.label.text = "E-mail: " + (realmData?[indexPath.row].user)!
        cell.labelPassword.text = "Пароль: " + "**********"
        return cell
    }
    @objc func optionSettingsAcction() {
        generator.impactOccurred()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var config = Realm.Configuration(
            schemaVersion: 1,
            
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
            })
        config.deleteRealmIfMigrationNeeded = true
        
        Realm.Configuration.defaultConfiguration = config
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let realm: Realm = {
            return try! Realm()
        }()
        
        let realmboxing = realm.objects(AccountModel.self)
        realmData = realmboxing
        guard let count = realmData?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        generator.impactOccurred()
        UIView.animate(withDuration: 0.5) {
            let cell  = tableView.cellForRow(at: indexPath) as? ProfileSelectCell
            cell!.content.layer.shadowOpacity = 0.7
            cell!.content.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.content.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell  = tableView.cellForRow(at: indexPath) as? ProfileSelectCell
            cell!.content.layer.shadowOpacity = 0.1
            cell!.content.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell!.content?.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectItem = indexPath.row
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        self.navigationController?.view.layer.add(transition, forKey: nil)
        for obj in (self.navigationController?.viewControllers)! {
            if obj is AccountEnterController {
                let vc: AccountEnterController =  obj as! AccountEnterController
                vc.tagSelectProfile = indexPath.row
                vc.pushAccountProfile = true
                self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
        
    }
}

