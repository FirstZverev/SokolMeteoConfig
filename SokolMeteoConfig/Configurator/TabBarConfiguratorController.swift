//
//  TabBarConfiguratorController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 16.06.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import UIDrawer
import FittedSheets

class TabBarConfiguratorController: UITabBarController, FirstConfiguratorDelegate, SecondConfiguratorDelegate, ThriedConfiguratorDelegate {
    
    let kBarHeight = 50
    var delegateTabBar: TabBarConfiguratorDelegate?
    let generator = UIImpactFeedbackGenerator(style: .light)
    let secondVC = ConfiguratorSecondController()
    let firstVC = ConfiguratorFirstController()
    let thriedVC = ConfiguratorThriedController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        firstVC.delegate = self
        let item = UITabBarItem()
        item.title = "ПЕРЕДАЧА ДАННЫХ"
        item.selectedImage = UIImage(named: "firstConfigurator ON")
        item.image = UIImage(named: "firstConfigurator OFF")
        self.tabBar.tintColor = UIColor.black
        firstVC.tabBarItem = item

        secondVC.delegate = self
        let item2 = UITabBarItem()
        item2.title = "ДОП. ДАТЧИКИ"
        item2.selectedImage = UIImage(named: "secondConfigurator ON")
        item2.image = UIImage(named: "secondConfigurator OFF")
        secondVC.tabBarItem = item2

        thriedVC.delegate = self
        let item3 = UITabBarItem()
        item3.title = "СОСТОЯНИЕ ПОДК."
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
    override func viewWillAppear(_ animated: Bool) {
        if Access_Allowed != 2 {
            delegateTabBar?.buttonTapSetAlert()
        } else {
            reload = 11
            delegateTabBar?.buttonTabBar()
        }
    }
    
    func buttonTapFirstConfigurator() {
        delegateTabBar?.buttonTabBar()
    }
    func buttonTapThriedConfigurator() {
        delegateTabBar?.buttonTabBar()
    }
    func buttonTapSecondConfigurator() {
        delegateTabBar?.buttonTabBar()
    }
    fileprivate func transitionSettingsApp() {
        generator.impactOccurred()
        let controller = ThriedMeteoData()
//        viewController.height = screenW - 50
//        viewController.topCornerRadius = 35
//        viewController.presentDuration = 0.5
//        viewController.dismissDuration = 0.2
//        viewController.modalPresentationStyle = .custom
        controller.delegate = self

        let sheetController = SheetViewController(
            controller: controller,
            sizes: [.percent(0.4), .fixed(screenH * 0.4), .fullscreen])
            
            
        // The size of the grip in the pull bar
        sheetController.gripSize = CGSize(width: 50, height: 6)

        // The color of the grip on the pull bar
        sheetController.gripColor = UIColor(white: 0.868, alpha: 1)

        // The corner radius of the sheet
        sheetController.cornerRadius = 35
            
        // minimum distance above the pull bar, prevents bar from coming right up to the edge of the screen
        sheetController.minimumSpaceAbovePullBar = 50

        // Set the pullbar's background explicitly
        sheetController.pullBarBackgroundColor = UIColor.white

        // Determine if the rounding should happen on the pullbar or the presented controller only (should only be true when the pull bar's background color is .clear)
        sheetController.treatPullBarAsClear = false

        // Disable the dismiss on background tap functionality
        sheetController.dismissOnOverlayTap = true

        // Disable the ability to pull down to dismiss the modal
        sheetController.dismissOnPull = true

        /// Allow pulling past the maximum height and bounce back. Defaults to true.
        sheetController.allowPullingPastMaxHeight = true

        /// Automatically grow/move the sheet to accomidate the keyboard. Defaults to true.
        sheetController.autoAdjustToKeyboard = true
        
        self.present(sheetController, animated: true)
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
//extension TabBarConfiguratorController: UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark, topGap: screenH / 3, modalWidth: 0, cornerRadius: 30)
//    }
//}
//extension TabBarConfiguratorController: BottomPopupDelegate {
//
//    func bottomPopupViewLoaded() {
//        print("bottomPopupViewLoaded")
//    }
//
//    func bottomPopupWillAppear() {
//        print("bottomPopupWillAppear")
//    }
//
//    func bottomPopupDidAppear() {
//        print("bottomPopupDidAppear")
//    }
//
//    func bottomPopupWillDismiss() {
//        print("bottomPopupWillDismiss")
//    }
//
//    func bottomPopupDidDismiss() {
//        print("bottomPopupDidDismiss")
//    }
//
//    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
//        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
//    }
//}
