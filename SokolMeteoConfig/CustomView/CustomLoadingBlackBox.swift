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
        progress.frame = .zero
        progress.type = .circleStrokeSpin
        progress.color = UIColor(rgb: 0xBE449E)
        progress.startAnimating()
    }
}
