//
//  Units.swift
//  SOKOL
//
//  Created by Володя Зверев on 16.04.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import Foundation

public struct Units {
    
    public let bytes: UInt64
    private let procentDouble: Double = 1_000
    private let procent: UInt64 = 1_000

    public var kilobytes: Double {
        return Double(bytes) / procentDouble
    }
    
    public var megabytes: Double {
        return kilobytes / procentDouble
    }
    
    public var gigabytes: Double {
        return megabytes / procentDouble
    }
    
    public init(bytes: UInt64) {
        self.bytes = bytes
    }
    
    public func getReadableUnit() -> String {
        
        switch bytes {
        case 0..<procent:
            return "\(bytes) Б"
        case procent..<(procent * procent):
            return "\(String(format: "%.2f", kilobytes)) КБ"
        case procent..<(procent * procent * procent):
            return "\(String(format: "%.2f", megabytes)) МБ"
        case (procent * procent * procent)...UInt64.max:
            return "\(String(format: "%.2f", gigabytes)) ГБ"
        default:
            return "\(bytes) Б"
        }
    }
}
