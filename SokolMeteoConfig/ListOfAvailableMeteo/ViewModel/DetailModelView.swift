//
//  DetailModelView.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 27.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class DetailModelView: DetailViewModelType {
    
    private var menu: Menu
    
    var description: String {
        return String(describing: "\(menu.id) and \(menu.name)")
    }
        
    init(menu: Menu) {
        self.menu = menu
    }
    
}
