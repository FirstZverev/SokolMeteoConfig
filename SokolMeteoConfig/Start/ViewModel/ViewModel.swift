//
//  ViewModel.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModel: TableViewViewModelType {
    
    var menuMain = [
            Menu(id: 1, name: "ПОДКЛЮЧЕНИЕ К МЕТЕОСТАНЦИИ"),
            Menu(id: 2, name: "НАСТРОЙКИ ПРОГРАММЫ"),
            Menu(id: 3, name: "ТЕХПОДДЕРЖКА"),
            Menu(id: 4, name: "РЕГИСТРАЦИЯ НА ПЛАТФОРМУ СОКОЛ МЕТЕО")
        ]
    
    func numberOfRows() -> Int {
        return menuMain.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
        let menu = menuMain[indexPath.row]
        return TableViewCellViewModel(menu: menu)
    }
}
