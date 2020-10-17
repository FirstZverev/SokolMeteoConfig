//
//  ViewModelStateController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModelState: TableViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    
    var menuMain = [
        Menu(id: 1, name: "Системное время", image: "time"),
        Menu(id: 2, name: "Состояние GSM"),
        Menu(id: 3, name: "Количество спутников GSM", image: "satellite"),
        Menu(id: 4, name: "Азимут по компасу", image: "compas"),
        Menu(id: 5, name: "Продольный наклон", image: "tilt"),
        Menu(id: 6, name: "Поперечный наклон", image: "tilt-1"),
        Menu(id: 7, name: "Состояние маяка"),
        Menu(id: 8, name: "Минуты (без часа) когда начнется цикл измерения и отправки сообщения", image: "min-1"),
        Menu(id: 9, name: "Минуты (без часа) когда нанется обмен с БМВД", image: "min"),
        Menu(id: 10, name: "Напряжение аккумулятора", image: "voltage"),
        Menu(id: 11, name: "Напряжение внешнего источника", image: "voltage"),
        Menu(id: 12, name: "..."),
        Menu(id: 13, name: "Уровень сигнала GSM", image: "gsm"),
        Menu(id: 14, name: "Количество переданных сообщений", image: "mail"),
        Menu(id: 15, name: "Накопленные события и ошибки"),

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
