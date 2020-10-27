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
    var menuMain2 : [Menu] = []
    
    var menuMain = [
        Menu(id: 1, name: "Системное время", image: "time", nameParametr: "QTIM"),
        Menu(id: 2, name: "Состояние GSM", nameParametr: "QGSM"),
        Menu(id: 3, name: "Количество спутников GSM", image: "satellite", nameParametr: "QGPS"),
        Menu(id: 4, name: "Азимут по компасу", image: "compas", nameParametr: "QAZI"),
        Menu(id: 5, name: "Продольный наклон", image: "tilt", nameParametr: "QPRO"),
        Menu(id: 6, name: "Поперечный наклон", image: "tilt-1", nameParametr: "QPOP"),
        Menu(id: 7, name: "Состояние маяка", nameParametr: "QBKN"),
        Menu(id: 8, name: "Минуты (без часа) когда начнется цикл измерения и отправки сообщения", image: "min-1", nameParametr: "QPAK"),
        Menu(id: 9, name: "Минуты (без часа) когда нанется обмен с БМВД", image: "min", nameParametr: "QBMT"),
        Menu(id: 10, name: "Напряжение аккумулятора", image: "voltage", nameParametr: "UBAT"),
        Menu(id: 11, name: "Напряжение внешнего источника", image: "voltage", nameParametr: "UEXT"),
        Menu(id: 12, name: "Объем сгенерированных фотографий", nameParametr: "KS"),
        Menu(id: 13, name: "Уровень сигнала GSM", image: "gsm", nameParametr: "RSSI"),
        Menu(id: 14, name: "Количество переданных сообщений", image: "mail", nameParametr: "TRAF"),
        Menu(id: 15, name: "Накопленные события и ошибки", nameParametr: "QEVS"),

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
