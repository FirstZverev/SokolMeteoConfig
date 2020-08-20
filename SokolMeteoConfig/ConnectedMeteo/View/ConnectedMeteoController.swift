//
//  ConnectedMeteoController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//
import UIKit
import Hero
import Stevia
import Lottie

protocol ConnectedMeteoDelegate: class {
    func buttonTap()
}

class ConnectedMeteoController: UIViewController, BlackBoxDelegate, TabBarDelegate, TabBarConfiguratorDelegate, UITabBarControllerDelegate {

    let starAnimationView = AnimationView(name: "success")
    let nextAnimationView = AnimationView(name: "success")
    var heightEnter: Float =  0.0
    var tableView: UITableView!
    var viewModel: TableViewViewModelType?
    let blackBoxVC = BlackBoxController()
    let tabBarVC = TabBarController()
    let tabarConfigVC = TabBarConfiguratorController()
    var initialY: CGFloat!
    var offset: CGFloat!
    let customNavigationBar = createCustomNavigationBar(title: "",fontSize: screenW / 22)

    weak var delegate: ConnectedMeteoDelegate?
    
    let deviceNameLabel: UILabel = {
        let label = UILabel()
        label.text = nameDevice
        label.font = UIFont(name: "FuturaPT-Medium", size: screenW / 22)
        label.frame = CGRect(x: 0, y: 300, width: screenW, height: 30)
        label.textAlignment = .center
        label.textColor = .black
//        label.sizeToFit()
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        view.isUserInteractionEnabled = true
        print("print")
//        customNavigationBar.title = "\(nameDevice)"
        deviceNameLabel.text = "\(nameDevice)"
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    lazy var alertView: CustomAlert = {
        let alertView: CustomAlert = CustomAlert.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
       let view = UIVisualEffectView(effect: blurEffect)
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            initialY = alertView.frame.origin.y
            alertView.center.y = (screenH - CGFloat(keyboardSize.height)) / 2
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        alertView.frame.origin.y = initialY
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initialY = alertView.frame.origin.y
        offset = -50
        registerTableView()
        blackBoxVC.delegate = self
        tabBarVC.delegateConnectedMeteo = self
        tabarConfigVC.delegateTabBar = self
//        customNavigationBar.title = "\(nameDevice)"
        viewModel = ViewModelConnected()
        self.hero.isEnabled = true
        customNavigationBar.hero.id = "ConnectToMeteo2"
        view.addSubview(customNavigationBar)
        backView.tintColor = .black
        view.addSubview(backView)
        view.sv(deviceNameLabel)
        deviceNameLabel.top(screenH / 12 - (12 + screenW / 22)).left(20).right(20)

        backView.addTapGesture{ [self] in
            self.navigationController?.popViewController(animated: true)
        }
//        greenView.height(50).width(50).centerInContainer()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        visualEffectView.addTapGesture {
            self.navigationController?.view.endEditing(true)
        }
    }
    
    private func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(ConnectedMeteoCell.self, forCellReuseIdentifier: "ConnectedMeteoCell")
    }
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.height(screenH - (screenH / 12)).width(screenW)
        tableView.top(screenH / 12)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white

        
        self.tableView = tableView
    }
    
    override func loadView() {
        super.loadView()
        createTableView()
    }
    
    func buttonTapBlackBox() {
        delegate?.buttonTap()
        print("blackbox")
    }
    
    func buttonTapTabBar() {
        delegate?.buttonTap()
        print("meteo")
    }
    func buttonTabBar() {
        delegate?.buttonTap()
        print("config")
    }
}

extension ConnectedMeteoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mainPassword == "" {
            setAlert()
            animateIn()
        } else {
            if indexPath.row == 4 {
                navigationController?.pushViewController(PasswordController(), animated: true)
            } else if indexPath.row == 2 {
                navigationController?.pushViewController(tabarConfigVC, animated: true)
                reload = 10
            } else if indexPath.row == 0 {
                navigationController?.pushViewController(tabBarVC, animated: true)
            } else if indexPath.row == 1 {
                navigationController?.pushViewController(blackBoxVC, animated: true)
            }
        }
    }
}

extension ConnectedMeteoController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell  = tableView.cellForRow(at: indexPath) as? ConnectedMeteoCell
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
            let cell  = tableView.cellForRow(at: indexPath) as? ConnectedMeteoCell
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectedMeteoCell", for: indexPath) as? ConnectedMeteoCell
        cell?.selectionStyle = .none
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
        if indexPath.row == 4 {
            cell!.hero.id = "PasswordToMeteo"
        } else if indexPath.row == 0 {
            cell!.hero.id = "OnlineToMeteo"
        } else if indexPath.row == 2 {
            cell!.hero.id = "Configurator"
        }
        cell?.selectionStyle = .none

        cell?.imageUI?.image = UIImage(named: "ThreedView\(indexPath.row + 1)")
        cell?.imageUI2?.image = UIImage(named: "ThreedView\(indexPath.row + 1)")
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
}
