//
//  SecondConfigCell.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 18.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class SecondConfigCell: UICollectionViewCell {
    
    var label: UILabel!
    weak var content: UIView!
    weak var imageUI: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override var bounds: CGRect {
            didSet {
                self.layoutIfNeeded()
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        let content = UIView()
        content.backgroundColor = .white
        content.translatesAutoresizingMaskIntoConstraints = false
        content.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        content.layer.shadowRadius = 3.0
        content.layer.shadowOpacity = 0.1
        content.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        content.layer.cornerRadius = 10
//        let touchDown = UITapGestureRecognizer(target:self, action: #selector(didTouchDown))
//        content.addGestureRecognizer(touchDown)

        self.contentView.addSubview(content)
        self.content = content
        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.content.addSubview(label)
        self.label = label
        
        let imageUI = UIImageView()
        imageUI.image = UIImage(named: "bmvd0")
        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        imageUI.layer.shadowRadius = 6.0
        imageUI.layer.shadowOpacity = 0.5
        imageUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        self.content.addSubview(imageUI)
        self.imageUI = imageUI
        
        NSLayoutConstraint.activate([
            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.content!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            self.label!.bottomAnchor.constraint(equalTo: self.content!.bottomAnchor, constant: -10),
            self.label!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor),
            self.label!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor),

            self.imageUI!.centerXAnchor.constraint(equalTo: self.content!.centerXAnchor),
            self.imageUI!.bottomAnchor.constraint(equalTo: self.label!.topAnchor, constant: -5),
            self.imageUI!.heightAnchor.constraint(equalToConstant: 40),
            self.imageUI!.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
