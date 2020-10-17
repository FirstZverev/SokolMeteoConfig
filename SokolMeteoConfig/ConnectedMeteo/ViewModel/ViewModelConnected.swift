//
//  ViewModel.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModelConnected: TableViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    
    var menuMain = [
            Menu(id: 1, name: "ОНЛАЙН ДАННЫЕ"),
            Menu(id: 2, name: "ЭКСПОРТ ДАННЫХ (ЧЕРНЫЙ ЯЩИК)"),
            Menu(id: 3, name: "КОНФИГУРАТОР"),
            Menu(id: 5, name: "ПАРОЛЬ")
        ]
    
    func numberOfRows() -> Int {
        return menuMain.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
        let menu = menuMain[indexPath.row]
        return TableViewCellViewModel(menu: menu)
    }
    
    func viewModelForSelectedRow() -> DetailViewModelType? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        return DetailModelView(menu: menuMain[selectedIndexPath.row])
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
}
