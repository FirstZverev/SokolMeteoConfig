//
//  BlackBoxMeteoData+Alert.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 27.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

extension BlackBoxMeteoDataController: AlertDelegate {
    
    func buttonClose() {
        animateOut()
    }
    func forgotTapped() {
        animateOut()
    }
    
    func buttonTapped() {
        animateOut()
        createAlertAccount()
    }
    
    func setupVisualEffectView() {
        navigationController?.view.addSubview(visualEffectView)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        visualEffectView.alpha = 0
    }
    
    func setAlert() {
        setupVisualEffectView()
        navigationController?.view.addSubview(alertView)
        alertView.center = view.center
        alertView.set(title: "Способ отправки", body: "", buttonTitle: "Отправить")
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
}

extension BlackBoxMeteoDataController: AlertAccountDelegate {
    
    func buttonAccountClose() {
        animateOutAccount()
    }
    
    func buttonAccountTapped() {
        print("123")
    }
    
    func setupVisualEffectViewAccount() {
        navigationController?.view.addSubview(visualEffectView)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        visualEffectView.alpha = 0
    }
    
    func setAlertAccount() {
        setupVisualEffectView()
        navigationController?.view.addSubview(alertViewAccount)
        alertViewAccount.center = view.center
        alertViewAccount.set(title: "Учетная запись sokolmeteo.com", body: "", buttonTitle: "Отправить")
    }
    
    func animateInAccount() {
        alertViewAccount.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertViewAccount.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertViewAccount.alpha = 1
            self.alertViewAccount.transform = CGAffineTransform.identity
        }
    }
    func animateOutAccount() {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.alertViewAccount.alpha = 0
                        self.alertViewAccount.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                        self.alertViewAccount.removeFromSuperview()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        })
    }
}
