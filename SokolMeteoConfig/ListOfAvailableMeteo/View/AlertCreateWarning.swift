//
//  AlertCreateWarning.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 28.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

extension DevicesDUController: AlertWarningDelegate {
    func buttonClose() {
        animateOut()
    }
    
    func buttonTapped() {
        animateOut()
        let  vc =  self.navigationController?.viewControllers.filter({$0 is StartViewController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    
    func setupVisualEffectView() {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: (UIApplication.shared.keyWindow?.rootViewController?.view.leadingAnchor)!).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: (UIApplication.shared.keyWindow?.rootViewController?.view.trailingAnchor)!).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: (UIApplication.shared.keyWindow?.rootViewController?.view.topAnchor)!).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: (UIApplication.shared.keyWindow?.rootViewController?.view.bottomAnchor)!).isActive = true
        visualEffectView.alpha = 0
    }
    
    func setAlert() {
        setupVisualEffectView()
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(alertView)
        alertView.center = view.center
        alertView.set(title: "Связь потеряна", body: "Соединение с метеостанцией \(nameDevice) прервано", buttonTitle: "Продолжить")
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
    fileprivate func animateOut() {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.alertView.alpha = 0
                        self.alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.alertView.removeFromSuperview()
        }
    }
}
