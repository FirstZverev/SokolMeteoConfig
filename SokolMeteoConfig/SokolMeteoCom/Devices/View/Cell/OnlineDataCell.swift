//
//  OnlineDataCell.swift
//  SOKOL
//
//  Created by Володя Зверев on 19.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class OnlineDataCell: UITableViewCell {
    
    var label: UILabel!
    var labelValue: UILabel!
    var imageUI: UIImageView!
    var nextImage: UIButton!
    var separator: UIView!

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
        label.font = UIFont(name:"FuturaPT-Light", size: screenW / 20)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        contentView.addSubview(label)
        self.label = label
        
        let labelValue = UILabel()
        labelValue.font = UIFont(name:"FuturaPT-Medium", size: screenW / 20)
        labelValue.textAlignment = .right
        labelValue.textColor = .black
        labelValue.text = "100 %"
        labelValue.translatesAutoresizingMaskIntoConstraints = false
        labelValue.numberOfLines = 0
        contentView.addSubview(labelValue)
        self.labelValue = labelValue
//        let labelMac = UILabel()
//        labelMac.font = UIFont(name:"FuturaPT-Light", size: screenW / 23)
//        labelMac.textAlignment = .left
//        labelMac.textColor = .black
//        labelMac.translatesAutoresizingMaskIntoConstraints = false
//        labelMac.numberOfLines = 0
//        contentView.addSubview(labelMac)
//        self.labelMac = labelMac
        
        let imageUI = UIImageView()
        imageUI.image = UIImage(named: "temperature")
        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        imageUI.layer.shadowRadius = 6.0
        imageUI.layer.shadowOpacity = 0.5
        imageUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageUI)
        self.imageUI = imageUI
        
        let nextImage = UIButton()
        nextImage.setImage(UIImage(named: "notifications"), for: .normal)
        nextImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nextImage)
        self.nextImage = nextImage

        
        NSLayoutConstraint.activate([
//            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            self.content!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            self.label!.centerYAnchor.constraint(equalTo: imageUI.centerYAnchor),
            self.label!.leadingAnchor.constraint(equalTo: self.imageUI!.trailingAnchor, constant: 10),
            self.label!.trailingAnchor.constraint(equalTo: self.nextImage!.leadingAnchor, constant: -10),
            self.label!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            self.label!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),

//            self.labelMac!.topAnchor.constraint(equalTo: self.label!.bottomAnchor, constant: 10),
//            self.labelMac!.leadingAnchor.constraint(equalTo: self.label!.leadingAnchor),
//            self.labelMac!.trailingAnchor.constraint(equalTo: self.nextImage!.leadingAnchor, constant: -20),

            self.imageUI!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            self.imageUI!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.imageUI!.heightAnchor.constraint(equalToConstant: 40),
            self.imageUI!.widthAnchor.constraint(equalToConstant: 40),
            
            self.labelValue!.trailingAnchor.constraint(equalTo: self.nextImage.leadingAnchor, constant: -10),
            self.labelValue!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            self.nextImage!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            self.nextImage!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.nextImage!.heightAnchor.constraint(equalToConstant: 25),
            self.nextImage!.widthAnchor.constraint(equalToConstant: 25),
            
            self.separator!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            self.separator!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            self.separator!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            self.separator!.heightAnchor.constraint(equalToConstant: 2),


        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
