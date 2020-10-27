//
//  ConfiguratorThriedController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 16.06.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class ConfiguratorThriedController : UIViewController {
    
    var delegate: ThriedConfiguratorDelegate?
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: 35, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 15, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height / 2
        backView.addSubview(back)
        return backView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customNavigationBar = createCustomNavigationBar(title: "LoRaWan",fontSize: 16.0)
        self.hero.isEnabled = true
        view.sv(customNavigationBar)
    }
    
}
