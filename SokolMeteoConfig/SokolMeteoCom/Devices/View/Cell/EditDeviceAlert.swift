//
//  EditDeviceAlert.swift
//  SOKOL
//
//  Created by Володя Зверев on 26.01.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import UIKit
import RealmSwift

extension DevicesController: AlertDelegate {
    
    func buttonClose2() {
        animateOut()
    }
    func forgotTapped2() {
        animateOut()
    }
    
    func buttonTapped2() {
        animateOut()
        if alertView.checkBoxOne.isChecked == true {
            actionPushAdd(edit: true)
        } else {
            networkManager.networkingPostRequestDeleteDevice(id: devicesList[tag].id!) { (result, error) in
                if result == "OK" {
                    DispatchQueue.main.async {
                        self.showToast(message: "\(devicesList[self.tag].name!) поставлена в очередь на удаление", seconds: 1.5)
                    }
                }
            }
        }
    }
    
    func setupVisualEffectView() {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(visualEffectView)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        visualEffectView.alpha = 0
    }
    
    func setAlert(name: String) {
        setupVisualEffectView()
        let window = UIApplication.shared.keyWindow!
        window.addSubview(alertView)
        alertView.center = view.center
        alertView.setEdit(title: "НАСТРОЙКИ \(name)", body: "", buttonTitle: "Выбрать", editOne: "Редактировать", editTwo: "Удалить")
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
