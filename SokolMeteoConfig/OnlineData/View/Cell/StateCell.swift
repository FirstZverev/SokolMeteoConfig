//
//  StateCell.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class StateCell: UITableViewCell {
    
    var label: UILabel?
    var imageUI: UIImageView?
    var labelTwo: UILabel?
    var separator: UIView!

    weak var viewModel: TableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            label?.text = viewModel.name
            imageUI?.image = UIImage(named: viewModel.image)
            labelTwo?.text = arrayStateMain["\(viewModel.nameParametr)"]
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
        
        backgroundColor = .white

        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Light", size: screenW / 21)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.contentView.addSubview(label)
        self.label = label
        
        let labelTwo = UILabel()
        labelTwo.font = UIFont(name:"FuturaPT-Medium", size: screenW / 21)
        labelTwo.textAlignment = .right
        labelTwo.textColor = .black
        labelTwo.text = "\(QGSM)"
        labelTwo.translatesAutoresizingMaskIntoConstraints = false
        labelTwo.numberOfLines = 0
        self.contentView.addSubview(labelTwo)
        self.labelTwo = labelTwo
        
        let imageUI = UIImageView()
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageUI)
        self.imageUI = imageUI
        
        let separator = UIView()
        separator.backgroundColor = UIColor(rgb: 0xECECEC)
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        self.separator = separator
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.label!.topAnchor, constant: -20),
            self.contentView.bottomAnchor.constraint(equalTo: self.label!.bottomAnchor, constant: 20),
            self.contentView.topAnchor.constraint(equalTo: self.labelTwo!.topAnchor, constant: -20),
            self.contentView.bottomAnchor.constraint(equalTo: self.labelTwo!.bottomAnchor, constant: 20),

            self.label!.leadingAnchor.constraint(equalTo: self.imageUI!.trailingAnchor, constant: 7),
            self.label!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.label!.trailingAnchor.constraint(equalTo: self.labelTwo!.leadingAnchor, constant: -30),
            self.label!.widthAnchor.constraint(equalToConstant: screenW / 2),

            self.labelTwo!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.labelTwo!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            self.labelTwo!.leadingAnchor.constraint(equalTo: self.label!.trailingAnchor),

            
            self.imageUI!.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.imageUI!.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            self.imageUI!.heightAnchor.constraint(equalToConstant: 40),
            self.imageUI!.widthAnchor.constraint(equalToConstant: 40),
            
//            self.nextImage!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
//            self.nextImage!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.nextImage!.heightAnchor.constraint(equalToConstant: 25),
//            self.nextImage!.widthAnchor.constraint(equalToConstant: 25),
            
            self.separator!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            self.separator!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            self.separator!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            self.separator!.heightAnchor.constraint(equalToConstant: 2),


        ])
    }
}
