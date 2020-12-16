//
//  TabBarSokolMeteoController.swift
//  SOKOL
//
//  Created by Володя Зверев on 13.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class TabBarSokolMeteoController: UITabBarController {
    
    let kBarHeight = 50
    var delegateConnectedMeteo: TabBarDelegate?
    var firstVC = DevicesController()
    let secondVC = ReportsController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let item = UITabBarItem()
        item.title = "УСТРОЙСТВА"
        item.selectedImage = UIImage(named: "devices_on")
        item.image = UIImage(named: "devices_off")
        self.tabBar.tintColor = UIColor.black
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        firstVC = DevicesController(collectionViewLayout: layout)
        firstVC.tabBarItem = item

        let item2 = UITabBarItem()
        item2.title = "ОТЧЕТЫ"
        item2.selectedImage = UIImage(named: "report_on")
        item2.image = UIImage(named: "report_off")
        secondVC.tabBarItem = item2
        
        let controllers = [firstVC, secondVC]
        self.tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        let viewController = controllers.map{UINavigationController(rootViewController: $0)}
        viewController[0].navigationBar.isHidden = true
        viewController[1].navigationBar.isHidden = true
        viewControllers = viewController.map{$0}


        
        for item in self.tabBar.items!{
              item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
              item.image = item.image?.withRenderingMode(.alwaysOriginal)
          }
    }
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage.colorForNavBar(color: UIColor(rgb: 0xF7F7F7))
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowRadius = 5.0
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        tabBar.layer.shadowOffset = CGSize.zero
        }
}
