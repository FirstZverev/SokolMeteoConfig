//
//  SavedReportsCell.swift
//  SOKOL
//
//  Created by Володя Зверев on 16.04.2021.
//  Copyright © 2021 zverev. All rights reserved.
//


import UIKit

class SavedReportsCell: UITableViewCell {
    
    var label: UILabel!
    var labelMac: UILabel!
    var labelSize: UILabel!
    var imageUI: UIImageView!
    var separator: UIView!
    var uiSwitch: UISwitch!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        
        contentView.backgroundColor = .white
        
        let separator = UIView()
        separator.backgroundColor = UIColor(rgb: 0xECECEC)
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        self.separator = separator

        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Medium", size: screenW / 21)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        contentView.addSubview(label)
        self.label = label
        
        let labelMac = UILabel()
        labelMac.font = UIFont(name:"FuturaPT-Light", size: screenW / 23)
        labelMac.textAlignment = .left
        labelMac.textColor = UIColor(rgb: 0x998F99)
        labelMac.translatesAutoresizingMaskIntoConstraints = false
        labelMac.numberOfLines = 1
        contentView.addSubview(labelMac)
        self.labelMac = labelMac
        
        let labelSize = UILabel()
        labelSize.font = UIFont(name:"FuturaPT-Light", size: screenW / 23)
        labelSize.textAlignment = .right
        labelSize.textColor = UIColor(rgb: 0x998F99)
        labelSize.translatesAutoresizingMaskIntoConstraints = false
        labelSize.numberOfLines = 1
        contentView.addSubview(labelSize)
        self.labelSize = labelSize
        
        let imageUI = UIImageView()
        imageUI.image = UIImage(named: "fileImage")
        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        imageUI.layer.shadowRadius = 6.0
        imageUI.layer.shadowOpacity = 0.5
        imageUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageUI)
        self.imageUI = imageUI
    
        
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.isOn = true
        uiSwitch.isHidden = true
        uiSwitch.onTintColor = .purple
        uiSwitch.addTarget(self, action: #selector(update), for: .editingChanged)
        contentView.addSubview(uiSwitch)
        self.uiSwitch = uiSwitch


        
        NSLayoutConstraint.activate([
            
            self.label!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            self.label!.leadingAnchor.constraint(equalTo: self.imageUI!.trailingAnchor, constant: 30),
            self.label!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),

            self.labelMac!.topAnchor.constraint(equalTo: self.label!.bottomAnchor, constant: 10),
            self.labelMac!.leadingAnchor.constraint(equalTo: self.label!.leadingAnchor),

            self.labelSize!.centerYAnchor.constraint(equalTo: self.labelMac!.centerYAnchor),
            self.labelSize!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),

            self.imageUI!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            self.imageUI!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.imageUI!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
//            self.imageUI!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            self.imageUI!.heightAnchor.constraint(equalToConstant: 40),
            self.imageUI!.widthAnchor.constraint(equalToConstant: 40),
            
            self.separator!.topAnchor.constraint(equalTo: self.labelMac!.bottomAnchor, constant: 10),
            self.separator!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            self.separator!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            self.separator!.heightAnchor.constraint(equalToConstant: 2),
            self.separator!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            

        ])
    }
    @objc func update() {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
