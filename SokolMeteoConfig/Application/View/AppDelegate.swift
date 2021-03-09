//
//  AppDelegate.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import YandexMapsMobile

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        YMKMapKit.setApiKey("ee8e40e7-b1c6-424f-91da-2542f45e5c3e")
        Thread.sleep(forTimeInterval: 2.0)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let vc = firstOpenApp(viewController: StartViewController(), viewControllerSecond: SwipingStartController(collectionViewLayout: layout))
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.hero.isEnabled = true
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        //        UIApplication.shared.statusBarStyle = .darkContent
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack


    func firstOpenApp(viewController: UIViewController,  viewControllerSecond: UIViewController) -> UIViewController {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            return viewController
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            return viewControllerSecond
        }
    }
    var myOrientation: UIInterfaceOrientationMask = .portrait
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return myOrientation
    }

}

