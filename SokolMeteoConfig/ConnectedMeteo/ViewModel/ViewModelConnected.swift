//
//  ViewModel.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModelConnected {
    
    private var menu = Menu(id: 1, name: "234")
    
    var name: String {
        return menu.name
    }
}
