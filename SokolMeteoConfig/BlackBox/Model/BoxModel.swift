//
//  BoxModel.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 22.09.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation
import RealmSwift

class BoxModel: Object {
    
    @objc dynamic var id: Int = 0

    @objc dynamic var nameDevice: String?
    @objc dynamic var time: String?

    @objc dynamic var parametrt: String?
    @objc dynamic var parametrWD: String?
    @objc dynamic var parametrWV: String?
    @objc dynamic var parametrWM: String?
    @objc dynamic var parametrPR: String?
    @objc dynamic var parametrHM: String?
    @objc dynamic var parametrRN: String?
    @objc dynamic var parametrUV: String?
    @objc dynamic var parametrUVI: String?
    @objc dynamic var parametrL: String?
    @objc dynamic var parametrLI: String?
    @objc dynamic var parametrUpow: String?
    @objc dynamic var parametrUext: String?
    @objc dynamic var parametrKS: String?
    @objc dynamic var parametrRSSI: String?
    @objc dynamic var parametrTR: String?
    @objc dynamic var parametrEVS: String?

    @objc dynamic var allString: String?

}
