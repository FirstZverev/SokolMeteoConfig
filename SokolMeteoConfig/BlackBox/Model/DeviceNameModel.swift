//
//  DeviceNameModel.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 22.09.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import RealmSwift

class DeviceNameModel: Object {
    @objc dynamic var nameDevice: String?
    @objc dynamic var IMEIDevice: String?
    @objc dynamic var passwordDevice: String?
}