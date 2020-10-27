//
//  ViewModelMoreDeviceBmvdPortHide.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 25.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModelMoreDeviceBmvdPortHide: TableViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    
    var menuMain = [
        Menu(id: 1, name: "", image: "temperature2", imageUbat: "intensiv2", ubat: "", rssi: ""),
        Menu(id: 2, name: "", image: "intensiv2", imageUbat: "temperature2", ubat: "", rssi: "-"),
        Menu(id: 3, name: "", image: "intensiv2", imageUbat: "temperature2", ubat: "Аналоговый датчик температуры почвы", rssi: "-"),
        Menu(id: 3, name: "", image: "intensiv2", imageUbat: "intensiv2", ubat: "", rssi: "-"),
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
