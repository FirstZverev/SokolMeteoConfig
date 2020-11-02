//
//  ModelViewBlackBox.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 29.09.2020.
//  Copyright © 2020 zverev. All rights reserved.
//
import Foundation

class ModelViewBlackBox: TableViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    
    var menuMain = [
        Menu(id: 1, name: " ", image: "Frame 60"),
        Menu(id: 2, name: "Температура", image: "temperature"),
        Menu(id: 3, name: "Направление ветра", image: "wind"),
        Menu(id: 4, name: "Скорость ветра", image: "wind-1"),
        Menu(id: 5, name: "Порыв ветра", image: "wind-2"),
        Menu(id: 6, name: "Атмосферное давление", image: "press"),
        Menu(id: 7, name: "Влажность", image: "moi"),
        Menu(id: 8, name: "Интенсивность осадков", image: "intensiv"),
        Menu(id: 9, name: "Уровень ультрафиолетового излучения", image: "uv"),
        Menu(id: 10, name: "Накопленное значение ультрафиолетового излучения", image: "uv-1"),
        Menu(id: 11, name: "Уровень освещенности", image: "sun"),
        Menu(id: 12, name: "Накопленное значение видимого излучения", image: "gr"),
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
