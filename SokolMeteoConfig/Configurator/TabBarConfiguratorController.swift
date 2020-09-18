//
//  TabBarConfiguratorController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 16.06.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import UIDrawer
import BottomPopup

class TabBarConfiguratorController: UITabBarController, FirstConfiguratorDelegate, ThriedConfiguratorDelegate {
    
    let kBarHeight = 50
    var delegateTabBar: TabBarConfiguratorDelegate?
    let generator = UIImpactFeedbackGenerator(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let firstVC = ConfiguratorFirstController()
        let item = UITabBarItem()
        item.title = "ПЕРЕДАЧА ДАННЫХ"
        item.selectedImage = UIImage(named: "firstConfigurator ON")
        item.image = UIImage(named: "firstConfigurator OFF")
        self.tabBar.tintColor = UIColor.black
        firstVC.tabBarItem = item
        firstVC.delegate = self

        let secondVC = ConfiguratorSecondController()
        let item2 = UITabBarItem()
        item2.title = "ДОП. ДАТЧИКИ"
        item2.selectedImage = UIImage(named: "secondConfigurator ON")
        item2.image = UIImage(named: "secondConfigurator OFF")
        secondVC.tabBarItem = item2
        
        let thriedVC = ConfiguratorThriedController()
        let item3 = UITabBarItem()
        item3.title = "Состояние подк."
        item3.selectedImage = UIImage(named: "thriedConfigurator ON")
        item3.image = UIImage(named: "thriedConfigurator OFF")
        thriedVC.tabBarItem = item3
        viewControllers = [firstVC, secondVC, thriedVC]
        self.tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        
        let viewTapThriedVC = UIView()
        viewTapThriedVC.backgroundColor = .clear
        viewTapThriedVC.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewTapThriedVC)
        viewTapThriedVC.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewTapThriedVC.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewTapThriedVC.heightAnchor.constraint(equalToConstant: defaultTabBarHeight + 40.0).isActive = true
        viewTapThriedVC.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 3).isActive = true

        viewTapThriedVC.addTapGesture { [self] in
            self.transitionSettingsApp()
        }
        for item in self.tabBar.items!{
              item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
              item.image = item.image?.withRenderingMode(.alwaysOriginal)
          }
    }
    
    
    func buttonTapFirstConfigurator() {
        delegateTabBar?.buttonTabBar()
    }
    func buttonTapThriedConfigurator() {
        delegateTabBar?.buttonTabBar()
    }
    fileprivate func transitionSettingsApp() {
        generator.impactOccurred()
        let viewController = ThriedMeteoData()
        viewController.height = 350
        viewController.topCornerRadius = 35
        viewController.presentDuration = 0.5
        viewController.dismissDuration = 0.2
        viewController.modalPresentationStyle = .custom
        viewController.delegate = self
//        viewController.transitioningDelegate = self
        self.present(viewController, animated: true)
    }
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        var newFrame = tabBar.frame
//        newFrame.size.height = newTabBarHeight
//        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage.colorForNavBar(color: UIColor(rgb: 0xF7F7F7))
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowRadius = 5.0
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        tabBar.layer.shadowOffset = CGSize.zero
        
//        tabBar.frame = newFrame
    }
}
extension TabBarConfiguratorController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark, topGap: screenH / 3, modalWidth: 0, cornerRadius: 30)
    }
}
extension TabBarConfiguratorController: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
