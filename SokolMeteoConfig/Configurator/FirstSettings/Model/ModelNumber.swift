//
//  ModelNumber.swift
//  SOKOL
//
//  Created by Володя Зверев on 11.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

enum Number: Int, CaseIterable {
    case zero
    case one
    case two
    case three
}
enum NumberString: String, CaseIterable {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
}

struct Numbers {
    var int: Int?
    var string: String?
    
    func channelsNumber() -> String {
        switch Number(rawValue: int ?? 0) {
        case .zero :
            return "0"
        case .one :
            return "1"
        case .two :
            return "2"
        case .three :
            return "3"
        default :
            return "error"
        }
    }
    func channelsString() -> Int {
        switch NumberString(rawValue: string ?? "") {
        case .zero :
            return 0
        case .one :
            return 1
        case .two :
            return 2
        case .three :
            return 3
        default :
            return 0
        }
    }
}
