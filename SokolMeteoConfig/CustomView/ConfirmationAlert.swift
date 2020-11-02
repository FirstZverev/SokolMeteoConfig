//
//  ConfirmationAlert.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 01.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

protocol ConfirmationAlertDelegate: class {
    func buttonTappedConfirmation()
    func closeAlertConfirmation()
}

class ConfirmationAlert: UIView {
    
    @IBOutlet weak var CustomEnter: UIButton!
    @IBOutlet weak var CustomTextField: UITextField!
    @IBOutlet weak var CustomMainLabel: UILabel!
    @IBOutlet weak var CustomImage: UIImageView!
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var CustomInfo: UILabel!
    
    weak var delegate: ConfirmationAlertDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        customeizingButton()
        customeizingContentView()
    }
    
    func set(title: String, body: String, buttonTitle: String) {
        CustomMainLabel.text = title
        CustomInfo.text = body
        CustomEnter.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func closeAlertAction(_ sender: Any) {
        delegate?.closeAlertConfirmation()
    }
    @IBAction func ActionButton(_ sender: Any) {
        delegate?.buttonTappedConfirmation()
    }
    
    
    func customeizingButton() {
        CustomEnter.layer.cornerRadius = 5
    }
    func customeizingContentView() {
        ContentView.layer.cornerRadius = 20
        ContentView.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        ContentView.layer.shadowRadius = 20.0
        ContentView.layer.shadowOpacity = 0.5
        ContentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
}