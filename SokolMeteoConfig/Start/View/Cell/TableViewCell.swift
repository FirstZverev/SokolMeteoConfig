//
//  TableViewCell.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var content: UIView?
    var label: UILabel?
    var imageUI: UIImageView?
    
    var label2: UILabel?
    var imageUI2: UIImageView?
    
    var int: Int?
    
    weak var viewModel: TableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            label?.text = viewModel.name
            label2?.text = viewModel.name
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
        
        let content = UIView()
        content.backgroundColor = .white
        content.translatesAutoresizingMaskIntoConstraints = false
        content.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        content.layer.shadowRadius = 3.0
        content.layer.shadowOpacity = 0.1
        content.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        content.layer.cornerRadius = 30
//        let touchDown = UITapGestureRecognizer(target:self, action: #selector(didTouchDown))
//        content.addGestureRecognizer(touchDown)

        self.contentView.addSubview(content)
        self.content = content
        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Medium", size: screenW / 20)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.contentView.addSubview(label)
        self.label = label
        
        let imageUI = UIImageView()
        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        imageUI.layer.shadowRadius = 6.0
        imageUI.layer.shadowOpacity = 0.5
        imageUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageUI)
        self.imageUI = imageUI
        
        let label2 = UILabel()
        label2.font = UIFont(name:"FuturaPT-Medium", size: screenW / 20)
        label2.textAlignment = .right
        label2.textColor = .black
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.numberOfLines = 0
        self.contentView.addSubview(label2)
        self.label2 = label2
        
        let imageUI2 = UIImageView()
        imageUI2.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        imageUI2.layer.shadowRadius = 6.0
        imageUI2.layer.shadowOpacity = 0.5
        imageUI2.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageUI2.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageUI2)
        self.imageUI2 = imageUI2
        
        NSLayoutConstraint.activate([
            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.content!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            self.label!.centerYAnchor.constraint(equalTo: self.content!.centerYAnchor),
            self.label!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: screenW / 12),
            self.label!.trailingAnchor.constraint(equalTo: self.imageUI!.leadingAnchor, constant: -screenW / 14),

            self.imageUI!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -screenW / 10),
            self.imageUI!.centerYAnchor.constraint(equalTo: self.content!.centerYAnchor),
            self.imageUI!.topAnchor.constraint(equalTo: self.content!.topAnchor, constant: screenW / 8),
            self.imageUI!.heightAnchor.constraint(equalToConstant: 71),
            self.imageUI!.widthAnchor.constraint(equalToConstant: 78),
            
            self.label2!.centerYAnchor.constraint(equalTo: self.content!.centerYAnchor),
//            self.label2!.leadingAnchor.constraint(equalTo: self.imageUI2!.trailingAnchor, constant: -screenW / 10),
            self.label2!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -screenW / 10),
            
            self.imageUI2!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: screenW / 10),
            self.imageUI2!.trailingAnchor.constraint(equalTo: self.label2!.leadingAnchor, constant: -screenW / 14),
            self.imageUI2!.centerYAnchor.constraint(equalTo: self.content!.centerYAnchor),
            self.imageUI2!.topAnchor.constraint(equalTo: self.content!.topAnchor, constant: screenW / 8),
            self.imageUI2!.heightAnchor.constraint(equalToConstant: 71),
            self.imageUI2!.widthAnchor.constraint(equalToConstant: 78),
        ])
    }
}
