//
//  File.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 04.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 10,
        bottom: 0,
        right: 10
    )
    init(placeholder string: String) {
        super.init(frame: .zero)
        attributedPlaceholder = NSAttributedString(string: string,attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xB9B9B9)])
        layer.cornerRadius = 5
        textColor = .black
        backgroundColor = .white
        layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        layer.borderWidth = 1.0
        tintColor = .purple
        keyboardAppearance = .light
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

}
