//
//  Protocols.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 06.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

protocol FirstConfiguratorDelegate: class {
    func buttonTapFirstConfigurator()
}
protocol ThriedConfiguratorDelegate: class {
    func buttonTapThriedConfigurator()
}

protocol TabBarConfiguratorDelegate: class {
    func buttonTabBar()
}
