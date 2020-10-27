//
//  SettingsBmvdModel.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 20.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

var macAddress = ""
var selectBmvd = ""

struct ModelSettingsBmvd {
    let text: String
    let textUpper: String
    let image: UIImage?
    let imageHuman: UIImage?
}

let configModelSettingsBmvd: [ModelSettingsBmvd] = [
    ModelSettingsBmvd(text: "", textUpper: "", image: UIImage(named: "bmvdSettingsOnePage"), imageHuman: UIImage(named: "ChanalsImage")),
    ModelSettingsBmvd(text: "Введите мак адрес вручную или сканируйте qr code внутри крышки", textUpper: "", image: UIImage(named: "bmvdSettingsTwoPage"), imageHuman: UIImage(named: "human 0")),
    ModelSettingsBmvd(text: "Подождите пока станция примет сигнал", textUpper: """
        1. Включить - установлено
        2. Вставьте батарейки
        """, image: UIImage(named: "bmvdSettingsThreePage"), imageHuman: UIImage(named: "human 0")),
    ModelSettingsBmvd(text: "После оба диода гаснут", textUpper: "Подождите пока станция примет сигнал", image: UIImage(named: "bmvdSettingsFourPage"), imageHuman: UIImage(named: "human 0")),
    ModelSettingsBmvd(text: """
        5-6 раз - уровень сигнала отличный
        3-4 раза - уровень сигнала хороший
        1-2 раза - уровень сигнала плохо
        """, textUpper: "Ждём установку связи БМВД со станцией"
                      , image: UIImage(named: "bmvdSettingsFivePage"), imageHuman: UIImage(named: "human 0")),
    ModelSettingsBmvd(text: """
        Для сохранения настроек необходимо
        удерживать кнопку SET.
        Красный диод проморгает несколько раз,
        после выключится - настройки сохранены.
        """, textUpper: ""
                      , image: UIImage(named: "bmvdSettingsSixPage"), imageHuman: UIImage(named: "human 0")),
]
