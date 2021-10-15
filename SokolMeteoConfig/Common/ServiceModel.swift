//
//  ServiceModel.swift
//  SOKOL
//
//  Created by Володя Зверев on 25.01.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import Foundation
import UIKit
struct ModelParametr {
    let name: String
    let image: String
    let code: String
}
class ServiceModel {
    
    let userPermissionId = [1 : "54480ce1-00eb-4179-a2b6-f74daa6b9e72", 2 : "54480ce1-00eb-4179-a2b6-f74daa6b9e73", 3 : "54480ce1-00eb-4179-a2b6-f74daa6b9e74",]
    
    func actionBack(nav: UINavigationController?) {
        guard let nav = nav else { return }
            nav.popToRootViewController(animated: true)
    }
    func imageForCode(code: String) -> UIImage {
        switch code {
        case "UV":
            return UIImage(named: "uv")!
        case "PR":
            return UIImage(named: "press")!
        case "Uext", "Upow":
            return UIImage(named: "voltage")!
        case "WD2":
            return UIImage(named: "wind")!
        case "HM":
            return UIImage(named: "moi")!
        case "UVI":
            return UIImage(named: "uv-1")!
        case "t":
            return UIImage(named: "temperature")!
        case "WM":
            return UIImage(named: "wind-2")!
        case "RN":
            return UIImage(named: "intensiv")!
        case "LI":
            return UIImage(named: "gr")!
        case "TR":
            return UIImage(named: "mail")!
        case "WV":
            return UIImage(named: "wind-1")!
        case "KS":
            return UIImage(named: "setings")!
        default:
            return UIImage(named: "setings")!
        }
    }
    var arrayParametr: [ModelParametr] = [
        ModelParametr(name: "Уровень ультрафиолета", image: "uv", code: "UV"),
        ModelParametr(name: "Атм.давление, гПа", image: "press", code: "PR"),
        ModelParametr(name: "Напряжение внешнего источника", image: "voltage", code: "Uext"),
        ModelParametr(name: "Направление ветра", image: "wind", code: "WD2"),
        ModelParametr(name: "Влажность", image: "moi", code: "HM"),
        ModelParametr(name: "Объем сгенерированных фотографий", image: "setings", code: "KS"),
        ModelParametr(name: "Накопленное значение ультрафиолетового излучения", image: "uv-1", code: "UVI"),
        ModelParametr(name: "Напр.пит., В", image: "voltage", code: "Upow"),
        ModelParametr(name: "Уровень освещенности", image: "sun", code: "L"),
        ModelParametr(name: "Направление ветра", image: "wind", code: "WD"),
        ModelParametr(name: "Атм.давление, мм.рт.ст.", image: "press", code: "PR1"),
        ModelParametr(name: "Точка росы, ⁰C", image: "temperature", code: "td"),
        ModelParametr(name: "Уровень сигнала GSM", image: "gsm", code: "RSSI"),
        ModelParametr(name: "Температура, ⁰C", image: "temperature", code: "t"),
        ModelParametr(name: "Порыв ветра", image: "wind-2", code: "WM"),
        ModelParametr(name: "Интенсивность осадков", image: "intensiv", code: "RN"),
        ModelParametr(name: "Накопленное значение видимого излучения", image: "gr", code: "LI"),
        ModelParametr(name: "Трафик", image: "mail", code: "TR"),
        ModelParametr(name: "Скорость ветра", image: "wind-1", code: "WV")
    ]
    
    func imageOnlineSokol(imageString: String) -> UIImage {
        switch imageString {
        case "PR", "PR1":
            return UIImage(named: "press")!
        case "t", "td":
            return UIImage(named: "temperature")!
        case "HM":
            return UIImage(named: "moi")!
        case "Upow", "Uext":
            return UIImage(named: "voltage")!
        case "RN":
            return UIImage(named: "intensiv")!
        case "WD":
            return UIImage(named: "wind")!
        case "TR":
            return UIImage(named: "mail")!
        case "WV", "WV1", "WV2":
            return UIImage(named: "wind-1")!
        case "UF", "UF1", "UF2", "UV":
            return UIImage(named: "uv")!
        case "UVI":
            return UIImage(named: "uv-1")!
        case "L":
            return UIImage(named: "sun")!
        case "LI":
            return UIImage(named: "gr")!
        case "RSSI":
            return UIImage(named: "gsm")!
        case "WM":
            return UIImage(named: "wind-2")!
        default:
            return UIImage(named: "setings")!
        }
    }
    func daysForecast() -> [String] {
        let calendar = Calendar.current
        let today = Date()
        let todays = calendar.date(byAdding: .day, value: 4, to: today)!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let twoDays = calendar.date(byAdding: .day, value: 2, to: today)!
        let threeDays = calendar.date(byAdding: .day, value: 3, to: today)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let todayStr = dateFormatter.string(from: todays)
        let tomorrowStr = dateFormatter.string(from: tomorrow)
        let twoDaysStr = dateFormatter.string(from: twoDays)
        let threeDaysStr = dateFormatter.string(from: threeDays)
        return [tomorrowStr, twoDaysStr, threeDaysStr, todayStr]
    }
    
    var sokolTemplateName = ["Шаблон", "Объект", "Интервал"]
    var sokolTemplateInfo = ["Не выбрано", "Не выбрано"]
    var tag = 0
}

