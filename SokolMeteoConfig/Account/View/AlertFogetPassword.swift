//
//  AlertFogetPassword.swift
//  SOKOL
//
//  Created by Володя Зверев on 19.03.2021.
//  Copyright © 2021 zverev. All rights reserved.
//
import UIKit

extension AccountEnterController: AlertDelegate {
    func buttonClose2() {
        animateOut()
    }
    func buttonTapped2() {
        animateOut()
        networkManager.networkingFogetPassword(email: alertView.CustomTextField.text ?? "") { (state, error) in
            guard let result = state else {return}
            if result == "OK" {
                DispatchQueue.main.async {
                    self.showToast(message: "Письмо отправлено на \(self.alertView.CustomTextField.text!)", seconds: 1.0)
                }
            } else {
                DispatchQueue.main.async {
                    self.showToast(message: "\(result)", seconds: 1.0)
                }
            }
        }
    }
    
    func forgotTapped2() {
     
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
        alertView.set(title: "Введите E-mail", body: "", buttonTitle: "Отправить")
        alertView.forgotPaswordLabel.isHidden = true
        alertView.CustomTextField.text = IMEITextField.text
        alertView.CustomTextField.isSecureTextEntry = false
        alertView.CustomTextField.keyboardType = .default
        alertView.CustomTextField.removeTarget(nil, action: nil, for: .allEvents)
        alertView.CustomTextField.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
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
}
