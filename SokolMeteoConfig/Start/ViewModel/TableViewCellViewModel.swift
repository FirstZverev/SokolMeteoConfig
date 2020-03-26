//
//  TableViewCellViewModel.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class TableViewCellViewModel: TableViewCellViewModelType {
    
    private var menu: Menu
    
    var name: String {
        return menu.name
    }
    
    var id: String {
        return String(describing: menu.id)
    }
    
    init(menu: Menu) {
        self.menu = menu
    }
}
