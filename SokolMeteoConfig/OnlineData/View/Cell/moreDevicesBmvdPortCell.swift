//
//  moreDevicesBmvdPortCell.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 25.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class moreDevicesBmvdPortCell: UITableViewCell {
    
    var label: UILabel!
    var labelUbat: UILabel!
    var labelRssi: UILabel!
    var imageUI: UIImageView!
    var nextImage: UIImageView!
    var separator: UIView!

    weak var viewModel: TableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            label?.text = viewModel.name
            imageUI?.image = UIImage(named: viewModel.image)
//            labelUbat.text = "Напряжение батареи: " + viewModel.ubat + " В"
//            labelRssi.text = "Уровень радиосигнала: " + viewModel.rssi + " дБ"
        }
    }
    
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
        
        let labelUbat = UILabel()
        labelUbat.font = UIFont(name:"FuturaPT-Light", size: screenW / 30)
        labelUbat.textAlignment = .left
        labelUbat.textColor = .black
        labelUbat.translatesAutoresizingMaskIntoConstraints = false
        labelUbat.numberOfLines = 0
        contentView.addSubview(labelUbat)
        self.labelUbat = labelUbat
        
        let labelRssi = UILabel()
        labelRssi.font = UIFont(name:"FuturaPT-Light", size: screenW / 30)
        labelRssi.textAlignment = .left
        labelRssi.textColor = .black
        labelRssi.translatesAutoresizingMaskIntoConstraints = false
        labelRssi.numberOfLines = 0
        contentView.addSubview(labelRssi)
        self.labelRssi = labelRssi
        
        let imageUI = UIImageView()
        imageUI.image = UIImage(named: "bmvd")
        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        imageUI.layer.shadowRadius = 6.0
        imageUI.layer.shadowOpacity = 0.5
        imageUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageUI)
        self.imageUI = imageUI
        
        let nextImage = UIImageView(image: UIImage(named: "nextImage"))
        nextImage.image = nextImage.image!.withRenderingMode(.alwaysTemplate)
        nextImage.tintColor = UIColor(rgb: 0x998F99)
        nextImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nextImage)
        self.nextImage = nextImage

        
        NSLayoutConstraint.activate([
//            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            self.content!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            self.label!.leadingAnchor.constraint(equalTo: self.imageUI!.trailingAnchor, constant: 20),
            self.label!.trailingAnchor.constraint(equalTo: self.nextImage!.leadingAnchor, constant: -20),
            self.label!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),

            self.labelUbat!.topAnchor.constraint(equalTo: self.label!.bottomAnchor, constant: 5),
            self.labelUbat!.leadingAnchor.constraint(equalTo: self.label!.leadingAnchor),
            self.labelUbat!.trailingAnchor.constraint(equalTo: self.nextImage!.leadingAnchor, constant: -20),
            
            self.labelRssi!.topAnchor.constraint(equalTo: self.labelUbat!.bottomAnchor, constant: 5),
            self.labelRssi!.leadingAnchor.constraint(equalTo: self.label!.leadingAnchor),
            self.labelRssi!.trailingAnchor.constraint(equalTo: self.nextImage!.leadingAnchor, constant: -20),
            self.labelRssi!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),


            self.imageUI!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            self.imageUI!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.imageUI!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
//            self.imageUI!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            self.imageUI!.heightAnchor.constraint(equalToConstant: 40),
            self.imageUI!.widthAnchor.constraint(equalToConstant: 40),
            
            self.nextImage!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
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
