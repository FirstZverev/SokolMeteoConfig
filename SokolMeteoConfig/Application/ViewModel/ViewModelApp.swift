//
//  ViewModelApp.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 30.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation
import UIKit

class ViewModelApp: ScreenSizeType {
    
    var screenSize: ScreenSize!
    
    func howSize() -> HowScreenSizeType? {
        return ViewModelAppSize(screnSize: screenSize!)
    }
}

class ViewModelAppSize: HowScreenSizeType {
    
    private var screnSize: ScreenSize
    
    var h: CGFloat {
        return CGFloat(screnSize.h)
    }
    
    var w: CGFloat {
        return CGFloat(screnSize.w)
    }
    
    init(screnSize: ScreenSize) {
        self.screnSize = screnSize
    }
}
