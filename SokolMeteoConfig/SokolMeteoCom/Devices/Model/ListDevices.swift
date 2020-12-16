//
//  ListDevices.swift
//  SOKOL
//
//  Created by Володя Зверев on 13.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

struct ListDevices: Decodable {
    let state: String?
    let errors, message, localMessage: String?
    let timestamp: String?
    let result: [DataDevices]?
}

// MARK: - Result
struct DataDevices: Decodable {
    let id, name, imei, password: String?
    let latitude, longitude: String?
    let forecastActive, exactFarmingActive, permittedToRead, permittedToWrite: Bool?
    let permittedToDelete: Bool?
    let params, permissions: [String]?
}
