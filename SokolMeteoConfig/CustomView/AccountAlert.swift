//
//  accountAlert.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 27.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

protocol AlertAccountDelegate: class {
    func buttonAccountTapped()
    func buttonAccountClose()
    func buttonAccountFirst()
    func buttonAccountSecond()
}

class AccountAlert: UIView {
    
    @IBOutlet weak var CustomEnter: UIButton!
    @IBOutlet weak var CustomMainLabel: UILabel!
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var CloseImage: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var changeButtonTwo: UIButton!
    
    @IBOutlet weak var nameDevice: UILabel!
    @IBOutlet weak var labelImei: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    
    @IBOutlet weak var labelEmail: UILabel!
    
    weak var delegate: AlertAccountDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        customeizingButton()
        customeizingContentView()
    }
    
    func set(title: String, nameDevice: String, labelImei: String, labelPassword: String, buttonTitle: String, labelEmail: String) {
        CustomMainLabel.text = title
        CustomEnter.setTitle(buttonTitle, for: .normal)
        self.nameDevice.text = nameDevice
        self.labelImei.text = "IMEI: " + labelImei
        self.labelPassword.text = "Пароль: " + labelPassword
        self.labelEmail.text = "e-mail: "  + labelEmail
    }
    
    @IBAction func ActionButton(_ sender: Any) {
        delegate?.buttonAccountTapped()
    }
    @IBAction func clouseButton(sender: Any) {
        delegate?.buttonAccountClose()
    }
    
    @IBAction func ActionButtonChangeFirst(_ sender: Any) {
        delegate?.buttonAccountFirst()
    }
    @IBAction func ActionButtonChangeSecond(_ sender: Any) {
        delegate?.buttonAccountSecond()
    }
    func customeizingButton() {
        CustomEnter.layer.cornerRadius = 10
        changeButton.layer.cornerRadius = 10
        changeButtonTwo.layer.cornerRadius = 10

    }

    func customeizingContentView() {
        ContentView.layer.cornerRadius = 20
        ContentView.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        ContentView.layer.shadowRadius = 20.0
        ContentView.layer.shadowOpacity = 0.5
        ContentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
}
