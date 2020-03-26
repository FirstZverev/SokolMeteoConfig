//
//  ViewModel.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

class ViewModel {
    
    private var menu = Menu(config: "ПОДКЛЮЧЕНИЕ К МЕТЕОСТАНЦИИ", settings: "НАСТРОЙКИ ПРОГРАММЫ", techSupporting: "ТЕХПОДДЕРЖКА", registration: "РЕГИСТРАЦИЯ НА ПЛАТФОРМУ СОКОЛ МЕТЕО")
    
    var config: String {
        return menu.config
    }
    
    var settings: String {
        return menu.settings
    }
    
    var techSupporting: String {
        return menu.techSupporting
    }
    
    var registration: String {
        return menu.registration
    }
}
