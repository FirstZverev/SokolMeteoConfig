//
//  ModelExchange.swift
//  SOKOL
//
//  Created by Володя Зверев on 11.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

enum Exchange: Int, CaseIterable {
    case zero
    case one
    case two
    case three
    case four
    case five
}
enum ExchangeString: String, CaseIterable {
    case zero = "5"
    case one = "10"
    case two = "15"
    case three = "20"
    case four = "30"
    case five = "60"

}

struct Exchanges {
    var int: Int?
    var string: String?
    
    func channelsNumber() -> String {
        switch Exchange(rawValue: int ?? 0) {
        case .zero :
            return "5"
        case .one :
            return "10"
        case .two :
            return "15"
        case .three :
            return "20"
        case .four :
            return "30"
        case .five :
            return "60"

        default :
            return "error"
        }
    }
    func channelsString() -> Int {
        switch ExchangeString(rawValue: string ?? "") {
        case .zero :
            return 0
        case .one :
            return 1
        case .two :
            return 2
        case .three :
            return 3
        case .four :
            return 4
        case .five :
            return 5
        default :
            return 0
        }
    }
}
