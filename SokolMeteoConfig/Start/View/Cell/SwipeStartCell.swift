//
//  SwipeStartCell.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 01.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class SwipeStartCell: UICollectionViewCell {
    
    var label: UILabel!
    weak var content: UIView!
    weak var imageUI: UIImageView!
    weak var imageHumanUI: UIImageView!
    weak var textView: UIView!
    
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
        content.backgroundColor = .clear
        content.translatesAutoresizingMaskIntoConstraints = false
//        content.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
//        content.layer.shadowRadius = 3.0
//        content.layer.shadowOpacity = 0.1
//        content.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        content.layer.cornerRadius = 10
//        let touchDown = UITapGestureRecognizer(target:self, action: #selector(didTouchDown))
//        content.addGestureRecognizer(touchDown)

        self.contentView.addSubview(content)
        self.content = content
        
        let imageUI = UIImageView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenW * 1.78))
        imageUI.image = UIImage(named: "swipe 0")
//        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
//        imageUI.layer.shadowRadius = 6.0
//        imageUI.layer.shadowOpacity = 0.5
//        imageUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        imageUI.translatesAutoresizingMaskIntoConstraints = false
//        self.content.addSubview(imageUI)
//        self.imageUI = imageUI
        
        let textView = UIView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 20
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        textView.layer.shadowRadius = 6.0
        textView.layer.shadowOpacity = 0.5
        textView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.content.addSubview(textView)
        self.textView = textView
        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Medium", size: screenW / 18)
        label.textAlignment = .center
        label.textColor = UIColor(rgb: 0x321550)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.textView.addSubview(label)
        self.label = label
        
        let imageHumanUI = UIImageView()
        imageHumanUI.image = UIImage(named: "human 0")
//        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
//        imageUI.layer.shadowRadius = 6.0
//        imageUI.layer.shadowOpacity = 0.5
//        imageUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageHumanUI.translatesAutoresizingMaskIntoConstraints = false
        self.content.addSubview(imageHumanUI)
        self.imageHumanUI = imageHumanUI
        
        NSLayoutConstraint.activate([
            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            self.content!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            self.label!.centerXAnchor.constraint(equalTo: self.textView!.centerXAnchor),
            self.label!.centerYAnchor.constraint(equalTo: self.textView!.centerYAnchor),
            self.label!.leadingAnchor.constraint(equalTo: self.textView!.leadingAnchor,constant: 30),
            self.label!.trailingAnchor.constraint(equalTo: self.textView!.trailingAnchor,constant: -30),

            self.imageHumanUI!.centerXAnchor.constraint(equalTo: self.content!.centerXAnchor),
            self.imageHumanUI!.centerYAnchor.constraint(equalTo: self.content!.centerYAnchor),
            
            self.textView!.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: screenH / 12),
            self.textView!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 20),
            self.textView!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.textView.heightAnchor.constraint(equalToConstant: screenH / 9)
//            self.imageUI!.heightAnchor.constraint(equalToConstant: 40),
//            self.imageUI!.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
