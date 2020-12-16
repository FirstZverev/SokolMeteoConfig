//
//  MessageError.swift
//  SOKOL
//
//  Created by Володя Зверев on 13.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

struct MessageError: Codable {
    let state, errors, message, localMessage: String?
    let timestamp, result: String?
}
