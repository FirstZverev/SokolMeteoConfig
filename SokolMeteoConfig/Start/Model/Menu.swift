//
//  Menu.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

struct Menu {
    var id: Int
    var name: String
    var image: String? = "setings"
    var ubat: String? = "0"
    var rssi: String? = "-99"
}

struct ModelStartSwipe {
    let text: String
    let image: UIImage?
    let imageHuman: UIImage?
}

let configModelStartSwipe: [ModelStartSwipe] = [
    ModelStartSwipe(text: "Cокол-М - когда погода работает на тебя!", image: UIImage(named: "swipe 0"), imageHuman: UIImage(named: "human 0")),
    ModelStartSwipe(text: "Просматривайте все актуальные данные", image: UIImage(named: "swipe 1"), imageHuman: UIImage(named: "human 1")),
    ModelStartSwipe(text: "Настраивайте беспроводной модуль БМВД", image: UIImage(named: "swipe 2"), imageHuman: UIImage(named: "human 2")),
    ModelStartSwipe(text: "", image: UIImage(named: "swipe 3"), imageHuman: UIImage(named: "human 3")),
]
