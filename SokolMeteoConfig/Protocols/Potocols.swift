//
//  File.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.06.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

protocol MeteoDelegate: class {
    func buttonTapMeteo()
}

protocol StateDelegate: class {
    func buttonTapState()
}

protocol BMVDDelegate: class {
    func buttonTapBMVD()
}
protocol TabBarDelegate: class {
    func buttonTapTabBar()
}
