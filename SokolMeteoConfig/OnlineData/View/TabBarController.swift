//
//  tabBarController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, MeteoDelegate, StateDelegate {
    
    let kBarHeight = 50
    var delegateConnectedMeteo: TabBarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let mainVC = MeteoDataController()
        let item = UITabBarItem()
        item.title = "МЕТЕО ДАННЫЕ"
        item.selectedImage = UIImage(named: "weather 1 ON")
        item.image = UIImage(named: "weather 1 OFF")
//        item.selectedImage.
        self.tabBar.tintColor = UIColor.black
        mainVC.tabBarItem = item
        mainVC.delegate = self
        
        let searchVC = StateController()
        let item2 = UITabBarItem()
        item2.title = "СОСТОЯНИЕ"
        item2.selectedImage = UIImage(named: "line 1 ON")
        item2.image = UIImage(named: "line 1 OFF")
        searchVC.tabBarItem = item2
        searchVC.delegate = self

        let profileVC = MoreDevicesController()
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
    }
    
    func buttonTapState() {
        print("buttonTapState")
        delegateConnectedMeteo?.buttonTapTabBar()
    }
  
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let newTabBarHeight = defaultTabBarHeight + 40.0
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage.colorForNavBar(color: UIColor(rgb: 0xF7F7F7))
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowRadius = 5.0
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        tabBar.layer.shadowOffset = CGSize.zero
        
        tabBar.frame = newFrame
    }
}
