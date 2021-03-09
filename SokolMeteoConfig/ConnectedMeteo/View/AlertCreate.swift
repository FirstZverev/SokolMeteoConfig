//
//  AlertCreate.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 27.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

extension ConnectedMeteoController: AlertDelegate, UITextFieldDelegate {
    func buttonClose2() {
        animateOut()
        let  vc =  self.navigationController?.viewControllers.filter({$0 is ConnectedMeteoController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    func forgotTapped2() {
        animateOut()
        let  vc =  self.navigationController?.viewControllers.filter({$0 is ConnectedMeteoController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
        self.navigationController?.pushViewController(passwordVC, animated: true)
        passwordVC.segmentedControl1.selectedSegmentIndex = 2
        passwordVC.scrollView.setContentOffset(CGPoint(x: screenW * 2 - 20, y: 0), animated: false)
    }
    
    func buttonTapped2() {
        reload = 0
        mainPassword = alertView.CustomTextField.text ?? ""
        alertView.CustomTextField.text = ""
        delegate?.buttonTap()
        animationSuccess()
        if demoMode {
            print("demo")
            Access_Allowed = 2
            if let viewControllers = navigationController?.viewControllers {
                for viewController in viewControllers {
                    if viewController.isKind(of: MeteoDataController.self) {
                        tabBarVC.mainVC.demoData()
                    }
                }
            }
        }
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController.isKind(of: PasswordController.self) {
                    
                }
            }
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:{
//            self.navigationController?.pushViewController(TabBarController(), animated: true)
//        })
    }
    
    func setupVisualEffectView() {
        navigationController?.view.addSubview(visualEffectView)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
//        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.alpha = 0
    }
    
    func setAlert() {
        reload = -1
//        view.addSubview(alertView)
        setupVisualEffectView()
        navigationController?.view.addSubview(alertView)
        alertView.center = view.center
        alertView.set(title: "Необходимо ввести пароль", body: "", buttonTitle: "Отправить")
        //alertView.leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
    }
    
    func animateIn() {
        alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertView.alpha = 1
            self.alertView.transform = CGAffineTransform.identity
        }
    }
    func animateOut() {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.alertView.alpha = 0
                        self.alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                        self.alertView.removeFromSuperview()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        })
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(rgb: 0xF06BCD).cgColor
        textField.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        textField.layer.shadowOpacity = 0.0
    }
}
