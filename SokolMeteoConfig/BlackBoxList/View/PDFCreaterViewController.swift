//
//  PDFCreaterViewController.swift
//  SOKOL
//
//  Created by Володя Зверев on 13.01.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import UIKit
import Charts

class PDFCreaterViewController : UIViewController {
    let generator = UIImpactFeedbackGenerator(style: .light)
    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
   
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let customNavigationBar = createCustomNavigationBar(title: "АРХИВ ДАННЫХ",fontSize: screenW / 22)
        self.hero.isEnabled = true
        view.sv(customNavigationBar, backView)
        customNavigationBar.hero.id = "pdf"
        backView.addTapGesture { [self] in self.popVC() }
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
