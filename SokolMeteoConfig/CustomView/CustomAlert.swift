//
//  CustomAlert.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 27.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

protocol AlertDelegate: class {
    func buttonTapped()
    func buttonClose()
}

class CustomAlert: UIView {
    
    @IBOutlet weak var CustomEnter: UIButton!
    @IBOutlet weak var CustomTextField: UITextField!
    @IBOutlet weak var CustomMainLabel: UILabel!
    @IBOutlet weak var CustomImage: UIImageView!
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var CloseImage: UIButton!
    
    weak var delegate: AlertDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        customeizingButton()
        customeizingContentView()
    }
    
    func set(title: String, body: String, buttonTitle: String) {
        CustomMainLabel.text = title
        CustomEnter.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func ActionButton(_ sender: Any) {
        delegate?.buttonTapped()
    }
    @IBAction func clouseButton(sender: Any) {
        delegate?.buttonClose()
    }
    
    
    func customeizingButton() {
        CustomEnter.layer.cornerRadius = 5
        CloseImage.frame.size = CGSize(width: 50, height: 50)
    }
    func customeizingContentView() {
        CustomTextField.backgroundColor = .lightGray
        CustomTextField.tintColor = .purple
        ContentView.layer.cornerRadius = 20
    }
}
