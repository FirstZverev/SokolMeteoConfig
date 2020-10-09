//
//  ViewModelBlackBoxTable.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 06.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModelBlackBoxTable: TableViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    
    var menuMain = [
        Menu(id: 1, name: "00:00", image: "arrow_drop_down_24px"),
        Menu(id: 2, name: "01:00", image: "temperature"),
        Menu(id: 3, name: "02:00", image: "wind"),
        Menu(id: 4, name: "03:00", image: "wind-1"),
        Menu(id: 5, name: "04:00", image: "wind-2"),
        Menu(id: 6, name: "05:00", image: "press"),
        Menu(id: 7, name: "06:00", image: "moi"),
        Menu(id: 8, name: "07:00", image: "intensiv"),
        Menu(id: 9, name: "08:00", image: "uv"),
        Menu(id: 10, name: "09:00", image: "uv-1"),
        Menu(id: 11, name: "10:00", image: "sun"),
        Menu(id: 12, name: "11:00", image: "sun"),
        Menu(id: 13, name: "12:00", image: "sun"),
        Menu(id: 14, name: "13:00", image: "sun"),
        Menu(id: 15, name: "14:00", image: "sun"),
        Menu(id: 16, name: "15:00", image: "sun"),
        Menu(id: 17, name: "16:00", image: "sun"),
        Menu(id: 18, name: "17:00", image: "sun"),
        Menu(id: 19, name: "18:00", image: "sun"),
        Menu(id: 20, name: "19:00", image: "sun"),
        Menu(id: 21, name: "20:00", image: "sun"),
        Menu(id: 22, name: "21:00", image: "sun"),
        Menu(id: 23, name: "22:00", image: "sun"),
        Menu(id: 24, name: "23:00", image: "sun"),
        Menu(id: 25, name: "23:30", image: "gr"),
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
