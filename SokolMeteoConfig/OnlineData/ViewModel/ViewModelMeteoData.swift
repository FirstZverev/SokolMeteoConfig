//
//  ViewModelMeteoData.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModelMeteoData: TableViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    
    var menuMain = [
            Menu(id: 0, name: ""),
            Menu(id: 1, name: "Напряжение аккумулятора"),
            Menu(id: 2, name: "Температура"),
            Menu(id: 3, name: "Напрявление ветра"),
            Menu(id: 4, name: "Скорость ветра"),
            Menu(id: 5, name: "Порыв ветра"),
            Menu(id: 6, name: "Атмосферное давление"),
            Menu(id: 7, name: "Влажность"),
            Menu(id: 8, name: "Интенсивность осадков"),
            Menu(id: 9, name: "Уровень ультрафиолетового излучения"),
            Menu(id: 10, name: "Накопленное значение ультрафиолетового излучения"),
            Menu(id: 11, name: "Уровень освещенности"),
            Menu(id: 12, name: "Накопленное значение видимого излучения"),
            Menu(id: 13, name: "Уровень сигнала GSM"),
            Menu(id: 14, name: "Количество переданных сообщений"),

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
