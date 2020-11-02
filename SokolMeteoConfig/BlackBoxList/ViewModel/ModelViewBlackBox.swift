//
//  ModelViewBlackBox.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 29.09.2020.
//  Copyright © 2020 zverev. All rights reserved.
//
import Foundation

class ModelViewBlackBox: TableViewViewModelTypeBlackBox {
    
    private var selectedIndexPath: IndexPath?
    
    var menuMain = [
        Menu(id: 1, name: " ", image: "Frame 60"),
        Menu(id: 2, name: "Температура", image: "temperature", nameParametr: "parametrt"),
        Menu(id: 3, name: "Направление ветра", image: "wind", nameParametr: "parametrWD"),
        Menu(id: 4, name: "Скорость ветра", image: "wind-1", nameParametr: "parametrWV"),
        Menu(id: 5, name: "Порыв ветра", image: "wind-2", nameParametr: "parametrWM"),
        Menu(id: 6, name: "Атмосферное давление", image: "press", nameParametr: "parametrPR"),
        Menu(id: 7, name: "Влажность", image: "moi", nameParametr: "parametrHM"),
        Menu(id: 8, name: "Интенсивность осадков", image: "intensiv", nameParametr: "parametrRN"),
        Menu(id: 9, name: "Уровень ультрафиолетового излучения", image: "uv", nameParametr: "parametrUV"),
        Menu(id: 10, name: "Накопленное значение ультрафиолетового излучения", image: "uv-1", nameParametr: "parametrUVI"),
        Menu(id: 11, name: "Уровень освещенности", image: "sun", nameParametr: "parametrL"),
        Menu(id: 12, name: "Накопленное значение видимого излучения", image: "gr", nameParametr: "parametrLI"),
        Menu(id: 13, name: "Напряжение аккумулятора", image: "voltage", nameParametr: "parametrUpow"),
        Menu(id: 14, name: "Напряжение внешнего источника", image: "voltage", nameParametr: "parametrUext"),
        Menu(id: 15, name: "Объем сгенерированных фотографий", nameParametr: "parametrKS"),
        Menu(id: 16, name: "Уровень сигнала GSM", image: "gsm", nameParametr: "parametrRSSI"),
        Menu(id: 17, name: "Количество переданных сообщений", image: "mail", nameParametr: "parametrTR"),
        Menu(id: 18, name: "Накопленные события и ошибки", nameParametr: "parametrEVS"),

    ]
    
    func numberOfRows() -> Int {
        return menuMain.count
    }
    func funcMenuMain() -> [Menu] {
        return menuMain
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
