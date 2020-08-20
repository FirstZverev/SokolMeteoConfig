//
//  MeteoDataCell.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class MeteoDataCell: UITableViewCell {
    
    var label: UILabel?
    var imageUI: UIImageView?
    var labelTwo: UILabel?
    
    var saveButton: UIImageView?
    var save2Button: UIImageView?
    var save3Button: UIImageView?


    weak var viewModel: TableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            label?.text = viewModel.name
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
        print(screenW)
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Light", size: screenW / 21)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.contentView.addSubview(label)
        self.label = label
        
        let labelTwo = UILabel()
        labelTwo.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        labelTwo.textAlignment = .right
        labelTwo.textColor = .black
        labelTwo.translatesAutoresizingMaskIntoConstraints = false
        labelTwo.numberOfLines = 0
        self.contentView.addSubview(labelTwo)
        self.labelTwo = labelTwo
        
        let imageUI = UIImageView()
        imageUI.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(imageUI)
        self.imageUI = imageUI
        
        let saveButton = UIImageView(image: UIImage(named: "imgPush"))
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(saveButton)
        self.saveButton = saveButton

        let save2Button = UIImageView(image: UIImage(named: "imgSave"))
        save2Button.layer.cornerRadius = 10
        save2Button.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(save2Button)
        self.save2Button = save2Button

        let save3Button = UIImageView(image: UIImage(named: "imgDelete"))
        save3Button.layer.cornerRadius = 10
        save3Button.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(save3Button)
        self.save3Button = save3Button

        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.label!.topAnchor, constant: -20),
            self.contentView.bottomAnchor.constraint(equalTo: self.label!.bottomAnchor, constant: 20),
            self.contentView.leadingAnchor.constraint(equalTo: self.label!.leadingAnchor, constant: -70),
            self.contentView.trailingAnchor.constraint(equalTo: self.label!.trailingAnchor, constant: 70),
            
            self.contentView.topAnchor.constraint(equalTo: self.labelTwo!.topAnchor, constant: -20),
            self.contentView.bottomAnchor.constraint(equalTo: self.labelTwo!.bottomAnchor, constant: 20),
            self.contentView.leadingAnchor.constraint(equalTo: self.labelTwo!.leadingAnchor, constant: -200),
            self.contentView.trailingAnchor.constraint(equalTo: self.labelTwo!.trailingAnchor, constant: 15),
            self.imageUI!.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.imageUI!.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),

            
            self.saveButton!.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.saveButton!.trailingAnchor.constraint(equalTo: save2Button.leadingAnchor, constant: -10),
            
            self.save2Button!.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.save2Button!.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),

            self.save3Button!.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
//            self.save3Button!.heightAnchor.constraint(equalToConstant: 30),
//            self.save3Button!.widthAnchor.constraint(equalToConstant: 100),
//            self.save3Button!.leadingAnchor.constraint(equalTo: save2Button.trailingAnchor, constant: 10),
            self.save3Button!.leadingAnchor.constraint(equalTo: save2Button.trailingAnchor, constant: 10),
        ])
    }
}
