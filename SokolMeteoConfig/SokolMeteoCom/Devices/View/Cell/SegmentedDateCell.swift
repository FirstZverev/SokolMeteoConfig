//
//  SegmentedDateCell.swift
//  SOKOL
//
//  Created by Володя Зверев on 29.01.2021.
//  Copyright © 2021 zverev. All rights reserved.

import UIKit

class SegmentedDateCell: UITableViewCell {
    
    var segmentedControl: UISegmentedControl!
    weak var delegate: ForecastDelegate?
    let viewModel: ServiceModel = ServiceModel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        
        contentView.backgroundColor = .white
        
        let daysForecast = viewModel.daysForecast()
        var items: [String]? = []
        if forecast.count == 1 {
            items?.append(daysForecast[0])
        } else {
            for i in 0...forecast.count - 1 {
                items?.append(daysForecast[i])
            }
        }
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        if #available(iOS 13.0, *) {
            segmentedControl.backgroundColor = UIColor(rgb: 0xBE449E)
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
            segmentedControl.selectedSegmentTintColor = UIColor.white.withAlphaComponent(0.5)
        } else {
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
            segmentedControl.backgroundColor = .white
            segmentedControl.tintColor = UIColor(rgb: 0xBE449E)
            segmentedControl.layer.cornerRadius = 10
        }
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(segmentedControl)
        self.segmentedControl = segmentedControl
        
        NSLayoutConstraint.activate([
            
            self.segmentedControl!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.segmentedControl!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            self.segmentedControl!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            self.segmentedControl!.heightAnchor.constraint(equalToConstant: 35),
            self.segmentedControl!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            self.segmentedControl!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),

        ])
    }
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        let tag = 2 - sender.selectedSegmentIndex
        delegate?.senderSelectedIndex(tag: tag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
