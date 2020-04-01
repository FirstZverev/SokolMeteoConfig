//
//  UIView+tap.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 01.04.2020.
//  Copyright © 2020 zverev. All rights reserved.
//
import UIKit

class SharedClass: NSObject {

    static let sharedInstance = SharedClass()
    
    //Tap gesture function
    func addTapGesture(view: UIView, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(tap)
    }
}

extension UIView {
    func addTapGesture(action : @escaping ()->Void ){
        let tap = MyTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
    }
    @objc func handleTap(_ sender: MyTapGestureRecognizer) {
        sender.action!()
    }
}

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var action : (()->Void)? = nil
}
