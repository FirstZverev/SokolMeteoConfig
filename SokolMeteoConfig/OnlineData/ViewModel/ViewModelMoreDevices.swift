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
        Menu(id: 1, name: "БМВД 1", image: "bmvd1", ubat: "-", rssi: "-"),
        Menu(id: 2, name: "БМВД 2", image: "bmvd2", ubat: "-", rssi: "-"),
        Menu(id: 3, name: "БМВД 3", image: "bmvd2", ubat: "-", rssi: "-"),
        Menu(id: 4, name: "БМВД 4", image: "bmvd2", ubat: "-", rssi: "-"),
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
