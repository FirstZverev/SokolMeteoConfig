//
//  ViewModelData.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 12.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModelData: TableViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    
    var menuMain = [
            Menu(id: 1, name: "Системное время"),
            Menu(id: 2, name: "Состояние GSM"),
            Menu(id: 3, name: "Количество переданных сообщений"),
            Menu(id: 4, name: "Количество спутников"),
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