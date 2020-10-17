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
    
    fileprivate func startLottie() {
        starAnimationView.stop()
        starAnimationView.removeFromSuperview()
        nextAnimationView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        nextAnimationView.center = CGPoint(x: alertView.frame.size.width / 2, y: CGFloat(heightEnter))
        alertView.addSubview(nextAnimationView)
        nextAnimationView.animationSpeed = 1.0
        nextAnimationView.play(fromFrame: 31, toFrame: 42) { (finished) in
            self.nextAnimationView.removeFromSuperview()
            self.alertView.CustomEnter.backgroundColor = UIColor(rgb: 0xB64894)
            self.alertView.CustomEnter.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            self.alertView.CustomEnter.alpha = 1
            
            
        }
    }
    
    fileprivate func animationAfter() {
        alertView.CustomEnter.alpha = 0.0
        starAnimationView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starAnimationView.center = CGPoint(x: alertView.frame.size.width / 2, y: CGFloat(heightEnter))
        alertView.addSubview(starAnimationView)
        starAnimationView.loopMode = .repeat(10)
        starAnimationView.animationSpeed = 1
        errorAnimationView.play(fromFrame: 15, toFrame: 31) { (finished) in
            self.startLottie()
            
        }
    }
    
    func animationWait() {
        UIView.animate(withDuration: 0.5, animations: {
            self.aminationBefore()
        }) { (_) in
            self.animationAfter()
//            self.animateOut()
//            reload = reloadInt
        }
    }
    
    func animationError(reloadInt : Int) {
        UIView.animate(withDuration: 0.5, animations: {
            self.aminationBefore()
        }) { (_) in
            self.animationAfter()
            self.animateOut()
//            reload = reloadInt
        }
    }
    
    func animationSuccess() {
        UIView.animate(withDuration: 0.5, animations: {
            self.animateOut()
        })
    }
}
