//
//  CustomLoadingBlackBox.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 29.09.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol CustomLoadingBlackBoxDelegate: class {
    func buttonTapped()
}

class CustomLoadingBlackBox: UIView {
    
    @IBOutlet weak var CustomEnter: UIButton!
    @IBOutlet weak var CustomTextField: UITextField!
    @IBOutlet weak var CustomMainLabel: UILabel!
    @IBOutlet weak var CustomImage: UIImageView!
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var CustomInfo: UILabel!
    @IBOutlet weak var progress: NVActivityIndicatorView!
    weak var delegate: CustomLoadingBlackBoxDelegate?

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
    
    @IBAction func ActionButton(_ sender: Any) {
        delegate?.buttonTapped()
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

        progress.frame = .zero
        progress.type = .circleStrokeSpin
        progress.color = UIColor(rgb: 0xBE449E)
        progress.startAnimating()
    }
}
