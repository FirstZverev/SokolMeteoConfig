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
class AccountModel: Object {
    @objc dynamic var user: String?
    @objc dynamic var password: String?
    @objc dynamic var save: Bool = false
}

class SelectAccount: Object {
    @objc dynamic var user: String?
    @objc dynamic var password: String?
    @objc dynamic var save: Bool = false
}
