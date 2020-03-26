//
//  TableViewCell.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var label: UILabel?
    
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
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 50)
        label.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        self.contentView.addSubview(label)
        self.label = label
    }
}
