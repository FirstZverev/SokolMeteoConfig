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
        Menu(id: 1, name: "Температура", image: "temperature", nameParametr: "t"),
        Menu(id: 2, name: "Направление ветра", image: "wind", nameParametr: "WD"),
        Menu(id: 3, name: "Скорость ветра", image: "wind-1", nameParametr: "WV"),
        Menu(id: 4, name: "Порыв ветра", image: "wind-2", nameParametr: "WM"),
        Menu(id: 5, name: "Атмосферное давление", image: "press", nameParametr: "PR"),
        Menu(id: 6, name: "Влажность", image: "moi", nameParametr: "HM"),
        Menu(id: 7, name: "Интенсивность осадков", image: "intensiv", nameParametr: "RN"),
        Menu(id: 8, name: "Уровень ультрафиолетового излучения", image: "uv", nameParametr: "UV"),
        Menu(id: 9, name: "Накопленное значение ультрафиолетового излучения", image: "uv-1", nameParametr: "UVI"),
        Menu(id: 10, name: "Уровень освещенности", image: "sun", nameParametr: "L"),
        Menu(id: 11, name: "Накопленное значение видимого излучения", image: "gr", nameParametr: "LI"),
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
