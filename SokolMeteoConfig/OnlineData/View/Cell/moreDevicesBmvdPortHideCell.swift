//
//  moreDevicesBmvdPortHideCell.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 25.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class moreDevicesBmvdPortHideCell: UITableViewCell {
    
    var label: UILabel!
    var labelUbat: UILabel!
    var labelRssi: UILabel!
    var labelRssiTwo: UILabel!
    var imageUI: UIImageView!
    var imageUITwo: UIImageView!

    weak var viewModel: TableViewCellViewModelType? {
        willSet(viewModel) {
//            guard let viewModel = viewModel else { return }
//            label?.text = viewModel.name
//            labelUbat?.text = viewModel.ubat
//            imageUI?.image = UIImage(named: viewModel.image)
//            imageUITwo?.image = UIImage(named: viewModel.imageUbat)

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
        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Light", size: screenW / 24)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        contentView.addSubview(label)
        self.label = label
        
        let labelUbat = UILabel()
        labelUbat.font = UIFont(name:"FuturaPT-Light", size: screenW / 24)
        labelUbat.textAlignment = .left
        labelUbat.textColor = .black
        labelUbat.translatesAutoresizingMaskIntoConstraints = false
        labelUbat.numberOfLines = 0
        contentView.addSubview(labelUbat)
        self.labelUbat = labelUbat
        
        let labelRssi = UILabel()
        labelRssi.font = UIFont(name:"FuturaPT-Medium", size: screenW / 24)
        labelRssi.textAlignment = .right
        labelRssi.textColor = .black
        labelRssi.translatesAutoresizingMaskIntoConstraints = false
        labelRssi.numberOfLines = 0
        contentView.addSubview(labelRssi)
        self.labelRssi = labelRssi
        
        let labelRssiTwo = UILabel()
        labelRssiTwo.font = UIFont(name:"FuturaPT-Medium", size: screenW / 24)
        labelRssiTwo.textAlignment = .right
        labelRssiTwo.textColor = .black
        labelRssiTwo.translatesAutoresizingMaskIntoConstraints = false
        labelRssiTwo.numberOfLines = 0
        contentView.addSubview(labelRssiTwo)
        self.labelRssiTwo = labelRssiTwo
        
        let imageUI = UIImageView()
        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        imageUI.layer.shadowRadius = 6.0
        imageUI.layer.shadowOpacity = 0.5
        imageUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageUI)
        self.imageUI = imageUI
        
        let imageUITwo = UIImageView()
        imageUITwo.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        imageUITwo.layer.shadowRadius = 6.0
        imageUITwo.layer.shadowOpacity = 0.5
        imageUITwo.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageUITwo.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageUITwo)
        self.imageUITwo = imageUITwo
        NSLayoutConstraint.activate([
//            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            self.content!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            self.label!.leadingAnchor.constraint(equalTo: self.imageUI.trailingAnchor, constant: 20),
            self.label!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            self.label!.widthAnchor.constraint(equalToConstant: screenW / 2 - 20),
            
            self.labelRssi!.centerYAnchor.constraint(equalTo: self.label.centerYAnchor),
            self.labelRssi!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            self.labelRssi!.leadingAnchor.constraint(equalTo: self.label.trailingAnchor, constant: 20),

            self.labelUbat!.leadingAnchor.constraint(equalTo: self.imageUI.trailingAnchor, constant: 20),
            self.labelUbat!.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 25),
            self.labelUbat!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            self.labelUbat!.widthAnchor.constraint(equalToConstant: screenW / 2 - 20),

            self.labelRssiTwo!.centerYAnchor.constraint(equalTo: self.labelUbat.centerYAnchor),
            self.labelRssiTwo!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            self.labelRssiTwo!.leadingAnchor.constraint(equalTo: self.labelUbat.trailingAnchor, constant: 20),


//            self.labelUbat!.topAnchor.constraint(equalTo: self.label!.bottomAnchor, constant: 5),
//            self.labelUbat!.leadingAnchor.constraint(equalTo: self.label!.leadingAnchor),
//            self.labelUbat!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            
//            self.labelRssi!.topAnchor.constraint(equalTo: self.labelUbat!.bottomAnchor, constant: 5),
//            self.labelRssi!.leadingAnchor.constraint(equalTo: self.label!.leadingAnchor),
//            self.labelRssi!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            self.labelRssi!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),


            self.imageUI!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            self.imageUI!.centerYAnchor.constraint(equalTo: self.label.centerYAnchor),
            self.imageUI!.widthAnchor.constraint(equalToConstant: 20),
            self.imageUI!.heightAnchor.constraint(equalToConstant: 20),

            self.imageUITwo!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            self.imageUITwo!.centerYAnchor.constraint(equalTo: self.labelUbat.centerYAnchor),
            self.imageUITwo!.widthAnchor.constraint(equalToConstant: 20),
            self.imageUITwo!.heightAnchor.constraint(equalToConstant: 20),


//            self.imageUI!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
//            self.imageUI!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
