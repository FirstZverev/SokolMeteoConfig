//
//  CellMain.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 27.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class CellMain: UITableViewCell {
    
    var content: UIView?
    var deviceName: UILabel?
    var dateLabel: UILabel?
    var stateLabel: UILabel?
    var timeLabel: UILabel?
    var imageUI: UIImageView?

    var int: Int?
    
    weak var viewModel: TableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            deviceName?.text = viewModel.name
            dateLabel?.text = viewModel.name
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
        self.deviceName = label
        
        let imageUI = UIImageView()
        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageUI)
        self.imageUI = imageUI
        
        let label2 = UILabel()
        label2.font = UIFont(name:"FuturaPT-Light", size: screenW / 20)
        label2.textAlignment = .left
        label2.textColor = .black
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.numberOfLines = 0
        self.contentView.addSubview(label2)
        self.dateLabel = label2
        
        let label3 = UILabel()
        label3.font = UIFont(name:"FuturaPT-Medium", size: screenW / 20)
        label3.textAlignment = .left
        label3.textColor = UIColor(rgb: 0x01AC5A)
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.numberOfLines = 0
        self.contentView.addSubview(label3)
        self.stateLabel = label3
        
        let label4 = UILabel()
        label4.font = UIFont(name:"FuturaPT-Light", size: screenW / 24)
        label4.textAlignment = .right
        label4.textColor = .black
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.numberOfLines = 1
        self.contentView.addSubview(label4)
        self.timeLabel = label4
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.content!.topAnchor,constant: -5),
            self.contentView.bottomAnchor.constraint(equalTo: self.content!.bottomAnchor, constant: 5),
            self.contentView.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: -15),
            self.contentView.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: 15),

//            self.content!.bottomAnchor.constraint(equalTo: self.stateLabel!.bottomAnchor, constant: 10),

            self.deviceName!.topAnchor.constraint(equalTo: self.content!.topAnchor, constant: 10),
            self.deviceName!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 15),
            self.deviceName!.trailingAnchor.constraint(equalTo: self.timeLabel!.leadingAnchor, constant: -15),
            
            self.dateLabel!.topAnchor.constraint(equalTo: self.deviceName!.bottomAnchor),
            self.dateLabel!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 15),
            self.dateLabel!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -15),
            
            self.stateLabel!.topAnchor.constraint(equalTo: self.dateLabel!.bottomAnchor, constant: 10),
            self.stateLabel!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 15),
            self.stateLabel!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -15),
            self.stateLabel!.bottomAnchor.constraint(equalTo: self.content!.bottomAnchor, constant: -10),

            self.timeLabel!.topAnchor.constraint(equalTo: self.content!.topAnchor, constant: 10),
            self.timeLabel!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -15),

            self.imageUI!.centerYAnchor.constraint(equalTo: self.stateLabel!.centerYAnchor),
            self.imageUI!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -15),

//            self.imageUI!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -screenW / 10),
//            self.imageUI!.centerYAnchor.constraint(equalTo: self.content!.centerYAnchor),
//            self.imageUI!.topAnchor.constraint(equalTo: self.content!.topAnchor, constant: screenW / 8),
//            self.imageUI!.heightAnchor.constraint(equalToConstant: 71),
//            self.imageUI!.widthAnchor.constraint(equalToConstant: 78),
        ])
    }
}
