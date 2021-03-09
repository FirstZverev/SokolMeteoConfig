//
//  ConfiguratorBMVDSecondController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 18.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ConfiguratorBMVDSecondController : UIViewController, SettingsBMVDDelegate {
    
    var tableView: UITableView!
    var a: CGFloat = 0
    let generator = UIImpactFeedbackGenerator(style: .light)
    var settingsBMVDvc = SettingsBMVDController()
    var delegate: SecondConfiguratorSettingsBMVDDelegate?

    lazy var viewAlpha: UIView = {
        let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return viewAlpha
    }()
    lazy var activityIndicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .zero, type: .ballGridPulse, color: UIColor.purple)
        view.frame.size = CGSize(width: 50, height: 50)
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.center = viewAlpha.center
        return view
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
        tableView.refreshControl = refreshControl
        self.tableView = tableView
    }
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .purple
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc func update(mySwitch: UISwitch) {
        let index = mySwitch.tag
        selectBmvd = "\(index)"
        if demoMode {
            arrayBmvdE[index] = "0"
            viewAlpha.isHidden = true
            tableView.reloadData()
        } else {
            viewAlpha.isHidden = false
        }
        reload = 8
        buttonTapSecondConfigurator()
    }
    @objc func refresh(sender:AnyObject) {
        reload = 10
        buttonTapSecondConfigurator()
        if demoMode {
            tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let customNavigationBar = createCustomNavigationBar(title: "КОНФИГУРАЦИЯ БМВД",fontSize: screenW / 22)
        self.hero.isEnabled = true
        createTableView()
        registerCell()
        view.sv(customNavigationBar, backView)
        backView.addTapGesture { [self] in self.popVC() }
    }
    override func viewWillAppear(_ animated: Bool) {
        reload = 10
        if demoMode {
            viewAlpha.isHidden = true
            tableView.reloadData()
        } else {
            viewAlpha.isHidden = false
        }
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(viewAlpha)
        buttonTapSecondConfigurator()
    }
    func viewControllerPush(viewController:  UICollectionViewController) -> UIViewController {
            return viewController
    }
    func buttonTapSecondConfigurator() {
        delegate?.buttonTapSecondConfigurator()
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SecondConfigBMVDCell.self, forCellReuseIdentifier: "SecondConfigBMVDCell")
    }
    
}

extension ConfiguratorBMVDSecondController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecondConfigBMVDCell", for: indexPath) as! SecondConfigBMVDCell
        cell.selectionStyle = .none
        cell.label.text = configBMVD[indexPath.row].name
        cell.imageUI.image = UIImage(named: configBMVD[indexPath.row].image)
        cell.labelMac.text = macLabel + arrayBmvdM[indexPath.row]
        cell.uiSwitch.addTarget(self, action: #selector(update), for: .valueChanged)
        cell.uiSwitch.tag = indexPath.row
        if arrayBmvdE[indexPath.row] == "1" {
            cell.uiSwitch.isOn = true
            cell.uiSwitch!.isHidden = false
            cell.nextImage!.isHidden = true
        } else {
            cell.uiSwitch!.isHidden = true
            cell.nextImage!.isHidden = false
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configBMVD.count
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        generator.impactOccurred()
        UIView.animate(withDuration: 0.5) {
            let cell  = tableView.cellForRow(at: indexPath) as? SecondConfigBMVDCell
//            cell!.imageUI!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.nextImage!.tintColor = UIColor(rgb: 0xBE449E)
            cell!.label!.textColor = UIColor(rgb: 0xBE449E)
            cell!.labelMac!.textColor = UIColor(rgb: 0xBE449E)
            cell?.contentView.backgroundColor = UIColor(rgb: 0xECECEC)
        }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell  = tableView.cellForRow(at: indexPath) as? SecondConfigBMVDCell
            cell!.nextImage!.tintColor = UIColor(rgb: 0x998F99)
            cell!.label!.textColor = .black
            cell!.labelMac!.textColor = .black
            cell?.contentView.backgroundColor = .white
//            cell!.imageUI!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//            cell!.label!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrayBmvdE[indexPath.row] == "0" {
            selectBmvd = "\(indexPath.row)"
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            settingsBMVDvc = viewControllerPush(viewController: SettingsBMVDController(collectionViewLayout: layout)) as! SettingsBMVDController
            settingsBMVDvc.delegate = self
            navigationController?.pushViewController(settingsBMVDvc, animated: true)
        }

    }
}
