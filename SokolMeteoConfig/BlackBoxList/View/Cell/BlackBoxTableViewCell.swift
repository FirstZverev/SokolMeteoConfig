//
//  BlackBoxTableViewCell.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 06.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class BlackBoxTableViewCell: UITableViewCell {
    
    var label: UILabel?
    var imageUI: UIImageView?
    var labelTwo: UILabel?

    weak var viewModel: TableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            imageUI?.image = UIImage(named: "timeBlackBox")
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

        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.label!.topAnchor, constant: -20),
            self.contentView.bottomAnchor.constraint(equalTo: self.label!.bottomAnchor, constant: 20),
            self.contentView.leadingAnchor.constraint(equalTo: self.label!.leadingAnchor, constant: -70),
            self.contentView.trailingAnchor.constraint(equalTo: self.label!.trailingAnchor, constant: 70),
            
            self.contentView.topAnchor.constraint(equalTo: self.labelTwo!.topAnchor, constant: -20),
            self.contentView.bottomAnchor.constraint(equalTo: self.labelTwo!.bottomAnchor, constant: 20),
            self.contentView.leadingAnchor.constraint(equalTo: self.labelTwo!.leadingAnchor, constant: -200),
            self.contentView.trailingAnchor.constraint(equalTo: self.labelTwo!.trailingAnchor, constant: 30),
            self.imageUI!.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.imageUI!.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),

        ])
    }
}

