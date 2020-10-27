//
//  UIViewController+Alert.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 23.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func showToast(message : String, seconds: Double = 2.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alert.view.backgroundColor = .white
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        alert.view.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        alert.view.layer.shadowRadius = 20.0
        alert.view.layer.shadowOpacity = 0.5
        alert.view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedString.Key.font : UIFont(name: "FuturaPT-Medium", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.purple]), forKey: "attributedMessage")
        
        self.present(alert, animated: true)

        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
