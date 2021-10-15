//
//  ListDeviceParametrs.swift
//  SOKOL
//
//  Created by Володя Зверев on 11.12.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation


struct ListDeviceParametrs: Decodable {
    let state, errors, message, localMessage: String?
    let timestamp: String?
    let result: [DeviceListResult]?
}

// MARK: - Result
struct DeviceListResult: Decodable {
    let id, code, name, expression: String?
    let calculationOrder: Int?
    let primary, show: Bool?
    let unit, minValue, maxValue, color: String?
    let records: [Records]?
}

struct Records: Decodable {
    let date, value : String?
}
