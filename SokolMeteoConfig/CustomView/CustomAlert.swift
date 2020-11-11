//
//  CustomAlert.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 27.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

protocol AlertDelegate: class {
    func buttonTapped2()
    func forgotTapped2()
    func buttonClose2()
}

class CustomAlert: UIView {
    
    @IBOutlet weak var CustomEnter: UIButton!
    @IBOutlet weak var CustomTextField: UITextField!
    @IBOutlet weak var CustomMainLabel: UILabel!
    @IBOutlet weak var CustomImage: UIImageView!
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var CloseImage: UIButton!
    
    @IBOutlet weak var forgotPaswordLabel: UIButton!
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
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        delegate?.forgotTapped2()
    }
    @IBAction func ActionButton(_ sender: Any) {
        delegate?.buttonTapped2()
    }
    @IBAction func clouseButton(sender: Any) {
        delegate?.buttonClose2()
    }
    @objc func textFieldDidMax(_ textField: UITextField) {
        print(textField.text!)
        checkMaxLength(textField: textField, maxLength: 7)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    
    func customeizingButton() {
        CustomEnter.layer.cornerRadius = 10
        CloseImage.frame.size = CGSize(width: 50, height: 50)
    }
    func customeizingContentView() {
        CustomTextField.layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        CustomTextField.layer.borderWidth = 1.0
        CustomTextField.layer.cornerRadius = 10
        CustomTextField.tintColor = .purple
        ContentView.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        ContentView.layer.shadowRadius = 20.0
        ContentView.layer.shadowOpacity = 0.5
        ContentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)

        
        ContentView.layer.cornerRadius = 20
        
        CustomTextField.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
    }
}
