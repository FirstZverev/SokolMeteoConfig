//
//  MeteoBlackBoxCell.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 07.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import RealmSwift

class MeteoBlackBoxCell: UITableViewCell {
    
    var label: UILabel?
    var imageUI: UIImageView?
    var labelTwo: UILabel?
    var nextImage: UIImageView!
    var separator: UIView!

    var saveButton: UIButton?
    var save2Button: UIButton?
    var save3Button: UIButton?

    let realm: Realm = {
        return try! Realm()
    }()


    weak var viewModel: TableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            label?.text = viewModel.name
            imageUI?.image = UIImage(named: viewModel.image)
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
        labelTwo.font = UIFont(name:"FuturaPT-Medium", size: screenW / 21)
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
        
        let nextImage = UIImageView(image: UIImage(named: "message"))
        nextImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nextImage)
        self.nextImage = nextImage
        
        let separator = UIView()
        separator.backgroundColor = UIColor(rgb: 0xECECEC)
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        self.separator = separator
        
        let saveButton = UIButton()
        saveButton.setImage(UIImage(named: "imgPush"), for: .normal)
//        saveButton.layer.cornerRadius = 10
        saveButton.isHidden = true
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(saveButton)
        self.saveButton = saveButton

        let save2Button = UIButton()
        save2Button.setImage(UIImage(named: "imgSave"), for: .normal)
        save2Button.layer.cornerRadius = 10
        save2Button.isHidden = true
        save2Button.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(save2Button)
        self.save2Button = save2Button

        let save3Button = UIButton()
        save3Button.setImage(UIImage(named: "imgDelete"), for: .normal)
        save3Button.layer.cornerRadius = 10
        save3Button.isHidden = true
        save3Button.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(save3Button)
        self.save3Button = save3Button

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
            self.labelTwo!.trailingAnchor.constraint(equalTo: self.nextImage.leadingAnchor, constant: -5),
            self.labelTwo!.leadingAnchor.constraint(equalTo: self.label!.trailingAnchor),

            
            self.imageUI!.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.imageUI!.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            self.imageUI!.heightAnchor.constraint(equalToConstant: 40),
            self.imageUI!.widthAnchor.constraint(equalToConstant: 40),
            
            self.nextImage!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            self.nextImage!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.nextImage!.heightAnchor.constraint(equalToConstant: 24),
            self.nextImage!.widthAnchor.constraint(equalToConstant: 24),

            self.separator!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            self.separator!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            self.separator!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            self.separator!.heightAnchor.constraint(equalToConstant: 2),


            self.saveButton!.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.saveButton!.trailingAnchor.constraint(equalTo: self.save2Button!.leadingAnchor, constant: -10),
            
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
