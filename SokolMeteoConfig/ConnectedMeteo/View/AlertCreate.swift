//
//  AlertCreate.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 27.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

extension ConnectedMeteoController: AlertDelegate {
    func buttonClose() {
        animateOut()
        let  vc =  self.navigationController?.viewControllers.filter({$0 is ConnectedMeteoController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    
    func buttonTapped() {
        reload = 0
        animationError(reloadInt : 2)
        mainPassword = alertView.CustomTextField.text ?? ""
        delegate?.buttonTap()
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
        alertView.set(title: "Введите пароль для просмотра", body: "", buttonTitle: "Ввести")
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
        }) { (_) in
            self.alertView.removeFromSuperview()
        }
    }
}
