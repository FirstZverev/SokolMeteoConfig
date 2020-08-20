//
//  Nib.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 27.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}
