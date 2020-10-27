//
//  ViewModelMoreDeviceBmvdPort.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 25.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModelMoreDeviceBmvdPort: TableViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    
    var menuMain = [
        Menu(id: 1, name: "Вход №1", image: "enter", ubat: "-", rssi: "-"),
        Menu(id: 2, name: "Вход №2", image: "enter2", ubat: "-", rssi: "-"),
        Menu(id: 3, name: "Вход №3", image: "enter3", ubat: "-", rssi: "-"),
        Menu(id: 4, name: "Вход №4", image: "enter4", ubat: "-", rssi: "-"),
    ]
    
    func numberOfRows() -> Int {
        return menuMain.count
    }
    
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
        let menu = menuMain[indexPath.section]
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
