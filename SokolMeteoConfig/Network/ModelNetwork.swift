//
//  ModelNetwork.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 28.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

struct Network: Decodable {
    let state: String?
    let errors: [String]?
    let timestamp: String?
    let result: [ResultDevice]?
}

// MARK: - Result
struct ResultDevice: Decodable {
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

struct OnlineNetwork: Decodable {
    let state, errors, message, localMessage: String?
    let timestamp: String?
    let result: [ResultOnline]?
}

// MARK: - Result
struct ResultOnline: Decodable {
    let date: String?
    let uv: Double?
    let pr: Double?
    let uext, wd2, hm, ks: Double?
    let uvi: Double?
    let upow: Double?
    let l, wd: Double?
    let pr1, td: Double?
    let rssi: Double?
    let t, wm: Double?
    let rn, li, tr: Double?
    let wv: Double?
    let evs: Double?

    enum CodingKeys: String, CodingKey {
        case date
        case uv = "UV"
        case pr = "PR"
        case uext = "Uext"
        case wd2 = "WD2"
        case hm = "HM"
        case ks = "KS"
        case uvi = "UVI"
        case upow = "Upow"
        case l = "L"
        case wd = "WD"
        case pr1 = "PR1"
        case td
        case rssi = "RSSI"
        case t
        case wm = "WM"
        case rn = "RN"
        case li = "LI"
        case tr = "TR"
        case wv = "WV"
        case evs = "EVS"
    }
}
