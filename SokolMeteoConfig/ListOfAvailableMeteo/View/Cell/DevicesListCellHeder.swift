//
//  DevicesListCellHeder.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 01.04.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class DevicesListCellHeder: UITableViewCell {
    
    weak var coverView: UIView!
    weak var titleLabel: UILabel!
    weak var levelLabel: UILabel!
    weak var separetor: UIView!
    weak var separetorUp: UIView!
    weak var btnConnet: UIView!
    weak var titleRSSI: UILabel!
    weak var titleRSSIImage: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {

        let separetor = UIView(frame: CGRect(x: 0, y: 53, width: screenW, height: 2))
        separetor.backgroundColor = UIColor(rgb: 0x959595)
        self.contentView.addSubview(separetor)
        self.separetor = separetor
        
        let separetorUp = UIView(frame: CGRect(x: 0, y: 5, width: screenW, height: 2))
        separetorUp.backgroundColor = UIColor(rgb: 0x959595)
        self.contentView.addSubview(separetorUp)
        self.separetorUp = separetorUp
        
//        let titleRSSI = UILabel(frame: CGRect(x: 50, y: 55, width: Int(screenWidth/2), height: 10))
//        titleRSSI.textColor = .white
//        titleRSSI.font = UIFont(name:"FuturaPT-Light", size: 14.0)
//        self.contentView.addSubview(titleRSSI)
//        self.titleRSSI = titleRSSI

//        let titleRSSIImage = UIImageView(frame: CGRect(x: 27, y: 55, width: 17, height: 11))
//        titleRSSIImage.image = #imageLiteral(resourceName: "dBm")
//        self.contentView.addSubview(titleRSSIImage)
//        self.titleRSSIImage = titleRSSIImage
        
//        let btnConnet = UIView(frame: CGRect(x: Int(screenWidth-140-20), y: 12, width: 140, height: 44))
//        btnConnet.translatesAutoresizingMaskIntoConstraints = false
//        btnConnet.backgroundColor = UIColor(rgb: 0xCF2121)
//        btnConnet.layer.cornerRadius = 22
//        let connect = UILabel(frame: CGRect(x: 0, y: 0, width: 140, height: 44))
//        connect.text = "Connect".localized(code)
//        connect.textColor = .white
//        connect.center.y = 22
//        connect.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
//        connect.textAlignment = .center
//        btnConnet.addSubview(connect)
//        self.contentView.addSubview(btnConnet)
//        self.btnConnet = btnConnet
        
        
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont(name: "FuturaPT-Light", size: 12)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
//        let levelLabel = UILabel(frame: .zero)
//        levelLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(levelLabel)
//        self.levelLabel = levelLabel

        NSLayoutConstraint.activate([
//            self.contentView.topAnchor.constraint(equalTo: self.btnConnet.topAnchor),
//            self.contentView.bottomAnchor.constraint(equalTo: self.btnConnet.bottomAnchor),
//            self.contentView.leadingAnchor.constraint(equalTo: self.btnConnet.leadingAnchor),
//            self.contentView.trailingAnchor.constraint(equalTo: self.btnConnet.trailingAnchor),
            
            self.contentView.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor, constant: 0),
            self.contentView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            
//            self.contentView.centerXAnchor.constraint(equalTo: self.btnConnet.centerXAnchor, constant: screenWidth/2),
//            self.contentView.centerYAnchor.constraint(equalTo: self.btnConnet.centerYAnchor),
//
//            self.contentView.centerXAnchor.constraint(equalTo: self.levelLabel.centerXAnchor, constant: -screenWidth/4),
//            self.contentView.centerYAnchor.constraint(equalTo: self.levelLabel.centerYAnchor),
        ])
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 18)
        self.titleLabel.textColor = .white
//        self.levelLabel.font = UIFont.systemFont(ofSize: 18)
//        self.levelLabel.textColor = .white
        setupTheme()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    fileprivate func setupTheme() {
            titleLabel.textColor = UIColor(rgb: 0x1F1F1F)
    }
}

