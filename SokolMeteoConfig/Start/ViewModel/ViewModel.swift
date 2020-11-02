//
//  ViewModel.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModel: TableViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    
    var menuMain = [
        Menu(id: 1, name: "ПОДКЛЮЧЕНИЕ К МЕТЕОСТАНЦИИ"),
        Menu(id: 2, name: "АРХИВ ДАННЫХ"),
        Menu(id: 3, name: "РЕГИСТРАЦИЯ НА СОКОЛ МЕТЕО"),
        Menu(id: 4, name: "ТЕХПОДДЕРЖКА"),
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
