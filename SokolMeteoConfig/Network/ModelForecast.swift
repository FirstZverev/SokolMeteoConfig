//
//  ModelForecast.swift
//  SOKOL
//
//  Created by Володя Зверев on 21.01.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import Foundation

struct Forecast: Decodable {
    let state: String?
    let errors: [String]?
    let message, localMessage, timestamp: String?
    let result: [ResultForecast]?
}

// MARK: - Result
struct ResultForecast: Decodable {
    let id: String?
    let created, changed, forecastDt: String?
    let tMin, tMax: Double?
    let rNight: Double?
    let rDay: Double?
    let wsNight: Double?
    let wsDay: Double?
    let wdNight: Double?
    let wdDay: Double?
    let hmNight: Double?
    let hmDay: Double?
    let p0Night: Double?
    let p0Day: Double?
}
