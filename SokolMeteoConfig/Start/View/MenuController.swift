//
//  MenuController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import UIDrawer

class MenuController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        viewShow()
        setupTheme()
        if isNight == true {
            themeSwitch.isOn = true
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var styleBackground: UILabel = {
        let styleBackground = UILabel(frame: CGRect(x: 0, y: 120, width: 300, height: 45))
        styleBackground.center.x = view.center.x
        styleBackground.textAlignment = .center
        styleBackground.text = "Внешний вид"
        styleBackground.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        styleBackground.textColor = .white
        return styleBackground
    }()
    lazy var themeSwitch: UISwitch = {
        let themeSwitch = UISwitch()
        themeSwitch.onTintColor = .lightGray
        if isNight {
            themeSwitch.thumbTintColor = UIColor(rgb: 0x1F2222)
        } else {
            themeSwitch.thumbTintColor = UIColor(rgb: 0xF5F5F5)
        }
        themeSwitch.addTarget(self, action: #selector(didChangeThemeSwitchValue), for: .valueChanged)
        return themeSwitch
    }()
    
    @objc func didChangeThemeSwitchValue() {
        if themeSwitch.isOn {
            if #available(iOS 13.0, *) {
//                themeService.switch(.dark)
            } else {
                dismiss(animated: true, completion: nil)
            }
            isNight = true
            UserDefaults.standard.set(isNight, forKey: "isNight")
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            themeSwitch.thumbTintColor = UIColor(rgb: 0x1F2222)
            themeSwitch.onTintColor = .gray
        } else {
            if #available(iOS 13.0, *) {
//                themeService.switch(.light)
                UIApplication.shared.statusBarStyle = UIStatusBarStyle.darkContent
            } else {
                dismiss(animated: true, completion: nil)
                UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
            }
            isNight = false
            UserDefaults.standard.set(isNight, forKey: "isNight")
            themeSwitch.thumbTintColor = .gray
        }
    }

    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "img")!)
        img.frame = CGRect(x: 0, y: screenH - 300, width: 201, height: 207)
        return img
    }()
    
    fileprivate lazy var textMain: UILabel = {
        let textMain = UILabel(frame: CGRect(x: 20, y: 20, width: screenW - 40, height: 20))
        textMain.center.x = view.center.x
        textMain.textAlignment = .center
        textMain.text = "Меню"
        textMain.font = UIFont(name:"FuturaPT-Medium", size: 20)
        textMain.frame.origin.x = 20
        return textMain
    }()

    fileprivate lazy var aboutApp: UILabel = {
        let aboutApp3 = UILabel(frame: CGRect(x: 0, y: 70, width: 300, height: 45))
        aboutApp3.center.x = view.center.x
        aboutApp3.textAlignment = .center
        aboutApp3.text = "Язык"
        aboutApp3.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp3.textColor = .white
        return aboutApp3
    }()
    
    private func viewShow() {
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        view.addSubview(bgImage)
        view.addSubview(textMain)
        let lineMain = UIView(frame: CGRect(x: 20, y: 50, width: 142, height: 1))
        lineMain.backgroundColor = UIColor(rgb: 0xCF2121)
        lineMain.center.x = view.center.x
        view.addSubview(lineMain)
        
        let aboutAppView = UIView(frame: CGRect(x: 0, y: 70, width: 300, height: 45))
        aboutAppView.backgroundColor = .clear
        aboutAppView.center.x = view.center.x

        view.addSubview(aboutApp)
        view.addSubview(aboutAppView)
        aboutAppView.addTapGesture {
            let alert = UIAlertController(title: "Язык", message: "", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "РУССКИЙ", style: .default, handler: { (_) in
                code = "ru"
                UserDefaults.standard.set(code, forKey: "code")
                self.aboutApp.text = "Language"
                self.textMain.text = "Menu"
                self.styleBackground.text = "Appearance"
            }))
            
            alert.addAction(UIAlertAction(title: "ENGLISH", style: .default, handler: { (_) in
                code = "en"
                UserDefaults.standard.set(code, forKey: "code")
                self.aboutApp.text = "Language"
                self.textMain.text = "Menu"
                self.styleBackground.text = "Appearance"
            }))
            
            alert.addAction(UIAlertAction(title: "PORTUGUÊS", style: .default, handler: { (_) in
                code = "pt-PT"
                UserDefaults.standard.set(code, forKey: "code")
                self.aboutApp.text = "Language"
                self.textMain.text = "Menu"
                self.styleBackground.text = "Appearance"
            }))
            alert.addAction(UIAlertAction(title: "ESPAÑOl", style: .default, handler: { (_) in
                code = "es"
                UserDefaults.standard.set(code, forKey: "code")
                self.aboutApp.text = "Language"
                self.textMain.text = "Menu"
                self.styleBackground.text = "Appearance"

            }))
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
                print("Назад")
            }))
            
            self.present(alert, animated: true)
        }

        
        themeSwitch.frame = CGRect(x: 0, y: 130, width: 50, height: 45)
        themeSwitch.center.x = screenW / 2 + 130
        view.addSubview(themeSwitch)
        view.addSubview(styleBackground)

    }
    
    fileprivate func setupTheme() {
        view.backgroundColor = UIColor(rgb: 0xFFFFFF)
        textMain.textColor = UIColor(rgb: 0x1F1F1F)
        aboutApp.textColor = UIColor(rgb: 0x1F1F1F)
        styleBackground.textColor = UIColor(rgb: 0x1F1F1F)
    }
}
extension MenuController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
