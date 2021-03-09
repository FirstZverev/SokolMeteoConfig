//
//  tabBarController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, MeteoDelegate, StateDelegate, BMVDDelegate {
    
    let kBarHeight = 50
    var delegateConnectedMeteo: TabBarDelegate?
    let mainVC = MeteoDataController()
    let searchVC = StateController()
    let profileVC = MoreDevicesController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mainVC.delegate = self
        let item = UITabBarItem()
        item.title = "МЕТЕО ДАННЫЕ"
        item.selectedImage = UIImage(named: "weather 1 ON")
        item.image = UIImage(named: "weather 1 OFF")
        self.tabBar.tintColor = UIColor.black
        mainVC.tabBarItem = item
        
        searchVC.delegate = self
        let item2 = UITabBarItem()
        item2.title = "СОСТОЯНИЕ"
        item2.selectedImage = UIImage(named: "line 1 ON")
        item2.image = UIImage(named: "line 1 OFF")
        searchVC.tabBarItem = item2

        profileVC.delegate = self
        let item3 = UITabBarItem()
        item3.title = "ДОП.УСТРОЙСТВА"
        item3.selectedImage = UIImage(named: "generic 1 ON")
        item3.image = UIImage(named: "generic 1 OFF")
        profileVC.tabBarItem = item3
        
        viewControllers = [mainVC, searchVC, profileVC]
        self.tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        
        for item in self.tabBar.items!{
              item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
              item.image = item.image?.withRenderingMode(.alwaysOriginal)
          }
    }
    
    func buttonTapMeteo() {
        print("buttonTapMeteo")
        delegateConnectedMeteo?.buttonTapTabBar()
        if demoMode {
            if Access_Allowed == 0 {
                delegateConnectedMeteo?.buttonTapSetAlert()
            }
        }
    }
    
    func buttonTapState() {
        print("buttonTapState")
        delegateConnectedMeteo?.buttonTapTabBarState()
        if demoMode {
            if Access_Allowed == 0 {
                delegateConnectedMeteo?.buttonTapSetAlert()
            }
        }
    }
    func buttonTapBMVD() {
        print("buttonTapBMVD")
        delegateConnectedMeteo?.buttonTapTabBar()
        if demoMode {
            if Access_Allowed == 0 {
                delegateConnectedMeteo?.buttonTapSetAlert()
            }
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
