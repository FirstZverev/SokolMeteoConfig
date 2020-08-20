//
//  ListOfAvailableMeteoController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import Hero
import Stevia

protocol MainDelegate: class {
    func buttonT()
}

class ListOfAvailableMeteoController: UIViewController {
    
    var label: UILabel!
    var devices: Devices?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .green
        let customNavigationBar = createCustomNavigationBar(title: "ПОДКЛЮЧЕНИЕ К МЕТЕОСТАНЦИИ",fontSize: 16.0)
        self.hero.isEnabled = true
        customNavigationBar.hero.id = "ConnectToMeteo"
        customNavigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popVC)))

        view.sv(
            customNavigationBar
        )
//        greenView.height(150).width(screenW).centerHorizontally().centerVertically(-230)
        
    }
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
