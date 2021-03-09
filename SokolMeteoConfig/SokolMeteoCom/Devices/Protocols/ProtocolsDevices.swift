//
//  ProtocolsDevices.swift
//  SOKOL
//
//  Created by Володя Зверев on 19.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

protocol DeviceDelegate: class {
    func buttonTap()
}

protocol DevicesDelegate: class {
    func buttonTap(tag: Int)
    func actionPushAdd(edit: Bool)
    func alertSetupVisualEffectView(name: String, tag: Int)
}

protocol ForecastDelegate: class {
    func senderSelectedIndex(tag: Int)
}

protocol SelectObectDelegate: class {
    func selected()
}
