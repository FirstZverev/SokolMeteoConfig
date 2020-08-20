//
//  ConfiguratorBMVDSecondController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 18.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class ConfiguratorBMVDSecondController : UIViewController {
    
    var tableView: UITableView!
    var a: CGFloat = 0
    let generator = UIImpactFeedbackGenerator(style: .light)

    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
    
    lazy var circlePlus: UIImageView = {
        let circlePlus = UIImageView(image: UIImage(named: "circle"))
        circlePlus.sizeToFit()
        circlePlus.translatesAutoresizingMaskIntoConstraints = false
        return circlePlus
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let customNavigationBar = createCustomNavigationBar(title: "КОНФИГУРАЦИЯ БМВД",fontSize: 16.0)
        self.hero.isEnabled = true
        createTableView()
        registerCell()
        view.sv(customNavigationBar, backView, circlePlus)
        backView.addTapGesture { [self] in popVC() }
        
        circlePlus.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        circlePlus.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circlePlus.addTapGesture {
            print("circlePlus")
        }
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
        cell.label.text = configBMVD[indexPath.row].name
        cell.imageUI.image = UIImage(named: configBMVD[indexPath.row].image)
        cell.labelMac.text = configBMVD[indexPath.row].mac
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
}
extension ConfiguratorBMVDSecondController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        print(offset)
        if (offset > a) {
            if offset <= 0 {
                offset = 0
            }
            circlePlus.transform = CGAffineTransform(translationX: 0, y: offset)
        } else if (offset < a) {
            if offset <= 0 {
                offset = 0
            }
            circlePlus.transform = CGAffineTransform(translationX: 0, y: offset)
        }
        a = offset
    }
}
