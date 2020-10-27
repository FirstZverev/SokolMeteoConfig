//
//  ViewModelMoreDevices.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 02.06.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModelMoreDevices: TableViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    
    var menuMain = [
        Menu(id: 1, name: "Беспроводной модуль 1", image: "bmvd1", ubat: "-", rssi: "-"),
        Menu(id: 2, name: "Беспроводной модуль 2", image: "bmvd2", ubat: "-", rssi: "-"),
        Menu(id: 3, name: "Беспроводной модуль 3", image: "bmvd3", ubat: "-", rssi: "-"),
        Menu(id: 4, name: "Беспроводной модуль 4", image: "bmvd4", ubat: "-", rssi: "-"),
        Menu(id: 5, name: "Беспроводной модуль 5", image: "bmvd5", ubat: "-", rssi: "-"),
        Menu(id: 6, name: "Беспроводной модуль 6", image: "bmvd6", ubat: "-", rssi: "-"),
        Menu(id: 7, name: "Беспроводной модуль 7", image: "bmvd7", ubat: "-", rssi: "-"),
        Menu(id: 8, name: "Беспроводной модуль 8", image: "bmvd8", ubat: "-", rssi: "-"),

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
