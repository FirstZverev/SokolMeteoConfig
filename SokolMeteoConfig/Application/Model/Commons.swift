//
//  Commons.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 30.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize {
    var w: Float
    var h: Float
}

let screenW = UIScreen.main.bounds.width
let screebH = UIScreen.main.bounds.height

func createCustomNavigationBar(title: String? = "Контроллер", fontSize: CGFloat? = 22.0) -> CustomNavigationView {
    let v = CustomNavigationView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: screenW,
                                               height: 100))
    v.title = title ?? "Контроллер"
    v.font = .systemFont(ofSize: fontSize!, weight: .bold)
    return v
}

var reload = 0
