//
//  SettingsBmvdCell.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 20.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class SettingsBmvdCell: UICollectionViewCell, UITextFieldDelegate {
    
    var label: UILabel!
    var labelUpper: UILabel!
    var labelFirst: UILabel!
    var labelSecond: UILabel!
    var textField: UITextField!
    weak var content: UIView!
    weak var imageUI: UIImageView!
    weak var imageHumanUI: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override var bounds: CGRect {
            didSet {
                self.layoutIfNeeded()
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        let content = UIView()
        content.backgroundColor = .clear
        content.translatesAutoresizingMaskIntoConstraints = false
//        content.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
//        content.layer.shadowRadius = 3.0
//        content.layer.shadowOpacity = 0.1
//        content.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        content.layer.cornerRadius = 10
//        let touchDown = UITapGestureRecognizer(target:self, action: #selector(didTouchDown))
//        content.addGestureRecognizer(touchDown)

        self.contentView.addSubview(content)
        self.content = content
        
        let imageUI = UIImageView()
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        self.content.addSubview(imageUI)
        self.imageUI = imageUI
        
//        let textView = UIView()
//        textView.backgroundColor = .white
//        textView.layer.cornerRadius = 20
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
//        textView.layer.shadowRadius = 6.0
//        textView.layer.shadowOpacity = 0.5
//        textView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        self.content.addSubview(textView)
//        self.textView = textView
        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.contentView.addSubview(label)
        self.label = label
        
        let labelUpper = UILabel()
        labelUpper.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        labelUpper.textAlignment = .left
        labelUpper.textColor = .black
        labelUpper.translatesAutoresizingMaskIntoConstraints = false
        labelUpper.numberOfLines = 0
        self.contentView.addSubview(labelUpper)
        self.labelUpper = labelUpper
        
        let labelFirst = UILabel()
        labelFirst.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        labelFirst.textAlignment = .left
        labelFirst.textColor = .black
        labelFirst.translatesAutoresizingMaskIntoConstraints = false
        labelFirst.numberOfLines = 2
        labelFirst.sizeToFit()
        self.contentView.addSubview(labelFirst)
        self.labelFirst = labelFirst
        
        let imageHumanUI = UIImageView()
        imageHumanUI.image = UIImage(named: "human 0")
//        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
//        imageUI.layer.shadowRadius = 6.0
//        imageUI.layer.shadowOpacity = 0.5
//        imageUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageHumanUI.translatesAutoresizingMaskIntoConstraints = false
        self.content.addSubview(imageHumanUI)
        self.imageHumanUI = imageHumanUI
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        textField.rightViewMode = .always
        textField.layer.cornerRadius = 5
        textField.delegate = self
        textField.textColor = .black
        textField.keyboardAppearance = .light
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        textField.layer.borderWidth = 1.0
        textField.tintColor = .purple
        self.content.addSubview(textField)
        self.textField = textField

        
        NSLayoutConstraint.activate([
            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            self.content!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            self.label!.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.label!.topAnchor.constraint(equalTo: self.imageHumanUI!.bottomAnchor, constant: 10),
            self.label!.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 30),
            self.label!.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -30),

            self.labelFirst!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 20),
            self.labelFirst.centerYAnchor.constraint(equalTo: self.textField!.centerYAnchor),
            self.labelFirst!.trailingAnchor.constraint(equalTo: self.textField!.leadingAnchor, constant: -10),

            self.textField!.leadingAnchor.constraint(equalTo: self.labelFirst!.trailingAnchor, constant: 10),
            self.textField!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.textField.bottomAnchor.constraint(equalTo: self.imageHumanUI!.topAnchor, constant: -10),
            self.textField!.heightAnchor.constraint(equalToConstant: 40),

            self.labelUpper!.bottomAnchor.constraint(equalTo: self.imageHumanUI!.topAnchor, constant: -10),
            self.labelUpper!.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),

            self.imageHumanUI!.centerXAnchor.constraint(equalTo: self.content!.centerXAnchor),
            self.imageHumanUI!.centerYAnchor.constraint(equalTo: self.content!.centerYAnchor),
            self.imageHumanUI!.heightAnchor.constraint(equalToConstant: screenW / 1.2),
            self.imageHumanUI!.widthAnchor.constraint(equalToConstant: screenW),

            self.imageUI!.topAnchor.constraint(equalTo: self.imageHumanUI!.bottomAnchor, constant: 10),
            self.imageUI!.centerXAnchor.constraint(equalTo: self.content!.centerXAnchor),

//            self.imageUI!.heightAnchor.constraint(equalToConstant: 40),
//            self.imageUI!.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = textField.text?.uppercased()
        do {
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let regex = try NSRegularExpression(pattern: "^([a-zA-Z0-9]{0,12})$", options: [])
            if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
                != nil {
                return true
            }
        }
        catch {
            print("ERROR")
        }
        return false
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
