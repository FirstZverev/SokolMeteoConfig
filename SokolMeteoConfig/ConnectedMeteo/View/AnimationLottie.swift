//
//  AnimationLottie.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 28.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

extension ConnectedMeteoController {
    fileprivate func aminationBefore() {
        heightEnter = Float(alertView.CustomEnter.frame.origin.y + (alertView.CustomEnter.frame.size.height / 2))
        alertView.CustomEnter.transform = CGAffineTransform.init(scaleX: 0.1, y: 1.0)
        alertView.CustomEnter.backgroundColor = .green
        alertView.CustomEnter.alpha = 0.1
    }

    
    func animationSuccess() {
        UIView.animate(withDuration: 0.5, animations: {
            self.animateOut()
        })
    }
}
