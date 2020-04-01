//
//  SeacrhBar+TextColor.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 01.04.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

extension UISearchBar {

    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as?
UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }

        set (newValue) {
            if let textField = self.value(forKey: "searchField") as?
UITextField  {
                textField.textColor = newValue
            }
        }
    }
}
