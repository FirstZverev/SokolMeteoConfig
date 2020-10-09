//
//  TableViewCellViewModel.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class TableViewCellViewModel: TableViewCellViewModelType {
    
    var ubat: String {
        return menu.ubat!
    }
    
    var rssi: String {
        return menu.rssi!
    }
    
    
    private var menu: Menu
    
    var name: String {
        return menu.name
    }
    
    var id: String {
        return String(describing: menu.id)
    }
    var image: String {
        return menu.image!
    }
    
    init(menu: Menu) {
        self.menu = menu
    }
}
