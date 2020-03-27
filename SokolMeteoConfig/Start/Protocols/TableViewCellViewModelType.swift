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
}