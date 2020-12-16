//
//  OnlineDataMapCell.swift
//  SOKOL
//
//  Created by Володя Зверев on 10.12.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import YandexMapsMobile

class OnlineDataMapCell: UITableViewCell {
    
    weak var mapView: YMKMapView!

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
        
        let mapView = YMKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.hero.id = "YandexMap"
        mapView.layer.cornerRadius = 20
        mapView.clipsToBounds = true
        self.contentView.addSubview(mapView)
        self.mapView = mapView

        
        NSLayoutConstraint.activate([
//            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            self.content!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            self.mapView!.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.mapView!.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.mapView!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            self.mapView!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.mapView!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.mapView!.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.mapView!.heightAnchor.constraint(equalToConstant: screenH / 3),

//            self.labelMac!.topAnchor.constraint(equalTo: self.label!.bottomAnchor, constant: 10),
//            self.labelMac!.leadingAnchor.constraint(equalTo: self.label!.leadingAnchor),
//            self.labelMac!.trailingAnchor.constraint(equalTo: self.nextImage!.leadingAnchor, constant: -20),


        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
