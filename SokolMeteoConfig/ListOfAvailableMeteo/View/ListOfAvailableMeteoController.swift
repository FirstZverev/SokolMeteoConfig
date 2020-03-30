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

class ListOfAvailableMeteoController: UIViewController {
    
    var label: UILabel!
    var devices: Devices?
    
    lazy var greenView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        let a = UILabel()
        a.text = "ПОДКЛЮЧЕНИЕ К МЕТЕОСТАНЦИИ"
        a.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 20)
        a.textAlignment = .center
        v.sv(a)
        a.width(screenW).height(150).centerHorizontally(0).centerVertically(0)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .green
        let customNavigationBar = createCustomNavigationBar(title: "ПОДКЛЮЧЕНИЕ К МЕТЕОСТАНЦИИ",fontSize: 16.0)
        self.hero.isEnabled = true
        customNavigationBar.hero.id = "ConnectToMeteo"
        
        view.backgroundColor = .blue
        
        customNavigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popVC)))

        view.sv(
            customNavigationBar
        )
        greenView.height(150).width(screenW).centerHorizontally().centerVertically(-230)
        
    }
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
