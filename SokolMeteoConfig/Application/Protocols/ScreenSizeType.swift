//
//  ScreenSizeType.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 30.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation
import UIKit

protocol ScreenSizeType {
    func howSize() -> HowScreenSizeType?
}

protocol HowScreenSizeType: class {
    var h: CGFloat { get }
    var w: CGFloat { get }
}
