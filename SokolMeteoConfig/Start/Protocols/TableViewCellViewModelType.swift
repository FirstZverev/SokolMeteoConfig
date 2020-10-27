//
//  TableViewCellViewModelType.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

protocol TableViewCellViewModelType: class {
    var name: String { get }
    var id: String { get }
    var image: String {get}
    var imageUbat: String {get}
    var ubat: String {get}
    var rssi: String {get}
    var nameParametr: String {get}

}
