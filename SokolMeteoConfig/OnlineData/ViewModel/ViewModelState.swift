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
            Menu(id: 1, name: "Системное время"),
            Menu(id: 2, name: "Состояние GSM"),
            Menu(id: 3, name: "Количество спутников GSM"),
            Menu(id: 4, name: "Азимут по компасу"),
            Menu(id: 5, name: "Продольный наклон"),
            Menu(id: 6, name: "Поперечный наклон"),
            Menu(id: 7, name: "Состояние маяка"),
            Menu(id: 8, name: "Минуты (без часа) когда начнется цикл измерения и отправки сообщения"),
            Menu(id: 9, name: "Минуты (без часа) когда нанется обмен с БМВД"),
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
