//
//  ModelNetwork.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 28.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

struct Network: Codable {
    let state: String?
    let errors: [String]?
    let timestamp: String?
    let result: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let id: Int?
    let author: String?
    let station: String?
    let created: Int?
    let start: Int?
    let end: Int?
    let sent: Int?
    let state: String?
    let details: [String]?
}
//typealias NetworkData = [NetworkDataNew]

