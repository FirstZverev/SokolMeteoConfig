//
//  ProfileSelectCell.swift
//  SOKOL
//
//  Created by Володя Зверев on 01.02.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import UIKit

class ProfileSelectCell: UITableViewCell {
    
    var content: UIView!
    var label: UILabel!
    var labelPassword: UILabel!
    var imageUI: UIImageView!

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
        let content = UIView()
        content.backgroundColor = .white
        content.translatesAutoresizingMaskIntoConstraints = false
        content.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        content.layer.shadowRadius = 3.0
        content.layer.shadowOpacity = 0.1
        content.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        content.layer.cornerRadius = 30
        self.contentView.addSubview(content)
        self.content = content
        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Light", size: screenW / 20)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.content.addSubview(label)
        self.label = label
        
        let labelMac = UILabel()
        labelMac.font = UIFont(name:"FuturaPT-Light", size: screenW / 23)
        labelMac.textAlignment = .left
        labelMac.textColor = UIColor(rgb: 0x998F99)
        labelMac.translatesAutoresizingMaskIntoConstraints = false
        labelMac.numberOfLines = 0
        self.content.addSubview(labelMac)
        self.labelPassword = labelMac
        
        let imageUI = UIImageView()
        imageUI.image = UIImage(named: "account_Image")
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        self.content.addSubview(imageUI)
        self.imageUI = imageUI
        
        NSLayoutConstraint.activate([
            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.content!.bottomAnchor.constraint(equalTo: labelPassword.bottomAnchor, constant: 10),
            
            self.label!.leadingAnchor.constraint(equalTo: self.imageUI!.trailingAnchor, constant: 20),
            self.label!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.label!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),

            self.labelPassword!.topAnchor.constraint(equalTo: self.label!.bottomAnchor, constant: 10),
            self.labelPassword!.leadingAnchor.constraint(equalTo: self.label!.leadingAnchor),
            self.labelPassword!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.labelPassword!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),

            self.imageUI!.leadingAnchor.constraint(equalTo: self.content.leadingAnchor, constant: 25),
            self.imageUI!.centerYAnchor.constraint(equalTo: self.content.centerYAnchor),
            self.imageUI!.heightAnchor.constraint(equalToConstant: 24),
            self.imageUI!.widthAnchor.constraint(equalToConstant: 24),
                

        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
