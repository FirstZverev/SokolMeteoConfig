//
//  Model.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 06.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

enum Channel: Int, CaseIterable {
    case gsm
    case iridium
    case gonec
    case lorawan
    case modbus
}
enum ChannelSting: String, CaseIterable {
    case gsm = "GSM"
    case iridium = "IRIDIUM"
    case gonec = "ГОНЕЦ"
    case lorawan = "LORA_WAN"
    case modbus = "MODBUS_ONLY"
}

struct Channels {
    var int: Int?
    var string: String?
    
    func channelsNumber() -> String {
        switch Channel(rawValue: int ?? 0) {
        case .gsm :
            return "GSM"
        case .iridium :
            return "IRIDIUM"
        case .gonec :
            return "ГОНЕЦ"
        case .lorawan :
            return "LORA_WAN"
        case .modbus :
            return "MODBUS_ONLY"
        default :
            return "error"
        }
    }
    func channelsString() -> Int {
        switch ChannelSting(rawValue: string ?? "") {
        case .gsm :
            return 0
        case .iridium :
            return 1
        case .gonec :
            return 2
        case .lorawan :
            return 3
        case .modbus :
            return 4
        default :
            return 0
        }
    }
}
