//
//  TemplatesCell.swift
//  SOKOL
//
//  Created by Володя Зверев on 01.02.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import UIKit

class TemplatesCell: UITableViewCell {
    
    var viewBackground: UIView!
    var labelName: UILabel!
    var labelPickerTo: UILabel!
    var labelPickerFrom: UILabel!

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
        self.viewBackground = content

        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Light", size: screenW / 20)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.viewBackground.addSubview(label)
        self.labelName = label
        
        let labelMac = UILabel()
        labelMac.font = UIFont(name:"FuturaPT-Light", size: screenW / 23)
        labelMac.textAlignment = .left
        labelMac.textColor = .black
        labelMac.translatesAutoresizingMaskIntoConstraints = false
        labelMac.numberOfLines = 0
        self.viewBackground.addSubview(labelMac)
        self.labelPickerTo = labelMac
        
        let labelFrom = UILabel()
        labelFrom.font = UIFont(name:"FuturaPT-Light", size: screenW / 23)
        labelFrom.textAlignment = .left
        labelFrom.textColor = .black
        labelFrom.translatesAutoresizingMaskIntoConstraints = false
        labelFrom.numberOfLines = 0
        self.viewBackground.addSubview(labelFrom)
        self.labelPickerFrom = labelFrom
                
        NSLayoutConstraint.activate([
            self.viewBackground!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.viewBackground!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            self.viewBackground!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.viewBackground!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.viewBackground!.bottomAnchor.constraint(equalTo: self.labelPickerFrom!.bottomAnchor, constant: 35),
//
            self.labelName!.topAnchor.constraint(equalTo: self.viewBackground!.topAnchor, constant: 15),
            self.labelName!.leadingAnchor.constraint(equalTo: self.viewBackground!.leadingAnchor, constant: 20),
            self.labelName!.trailingAnchor.constraint(equalTo: self.viewBackground!.trailingAnchor, constant: -20),

            self.labelPickerTo!.topAnchor.constraint(equalTo: self.labelName!.bottomAnchor, constant: 30),
            self.labelPickerTo!.leadingAnchor.constraint(equalTo: self.viewBackground!.leadingAnchor, constant: 40),
            self.labelPickerTo!.trailingAnchor.constraint(equalTo: self.viewBackground!.trailingAnchor, constant: -40),

            self.labelPickerFrom!.topAnchor.constraint(equalTo: self.labelPickerTo!.bottomAnchor, constant: 30),
            self.labelPickerFrom!.leadingAnchor.constraint(equalTo: self.viewBackground!.leadingAnchor, constant: 40),
            self.labelPickerFrom!.trailingAnchor.constraint(equalTo: self.viewBackground!.trailingAnchor, constant: -40),

        ])
    }
    
    @objc func update() {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
