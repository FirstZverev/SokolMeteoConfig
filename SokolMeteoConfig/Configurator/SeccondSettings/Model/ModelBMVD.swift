//
//  ModelBMVD.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 18.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

struct BMVDType {
    let name: String
    let image: String
    var mac: String? = "\(macLabel)" + "FFFFFFFFFFFFFFFF"
    var alpha: Float? = 1.0
    var isEnabled: Bool? = true
}

let macLabel = "Mac: "

let numberBMVD: [BMVDType] = [
    BMVDType(name: "Беспроводной модуль", image: "bmvd"),
    BMVDType(name: "УЗ анемометр", image: "uz", alpha: 0.5, isEnabled: false),
    BMVDType(name: "Снежный покров", image: "dgv", alpha: 0.5, isEnabled: false),
    BMVDType(name: "ModBus RTU", image: "modbus", alpha: 0.5, isEnabled: false)
]
let configBMVD: [BMVDType] = [
    BMVDType(name: "БМВД №1", image: "bmvd", mac: macLabel + "FFFFFFFFFFFF0000"),
    BMVDType(name: "БМВД №2", image: "bmvd"),
    BMVDType(name: "БМВД №3", image: "bmvd"),
    BMVDType(name: "БМВД №4", image: "bmvd"),
    BMVDType(name: "БМВД №5", image: "bmvd"),
    BMVDType(name: "БМВД №6", image: "bmvd"),
    BMVDType(name: "БМВД №7", image: "bmvd"),
    BMVDType(name: "БМВД №8", image: "bmvd"),
    

]
