//
//  cellDataPeripheral.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 14.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation
import CoreBluetooth

struct cellDataPeripheral {
    var opened = Bool()
    var title = String()
    var sectionData = [String()]
}

var CBPeripheralForDisconnect : CBPeripheral!
var CBServiceForDisconnect : CBService!

struct ListComandBluetooth {
    init(mainPassword: String) {
        let valueAll = "PWD_USER,\(mainPassword)\r\n"
    }
    let valueAll = "PWD_USER,\(mainPassword)\r\n"
    let changePassword = "PWD_CHANGE_USER,\(newPassword)\r\n"
    let changePasswordService = "PWD_CHANGE_SERVICE,\(newPassword)\r\n"
    let valueAll1 = "Get_State"
    let valueOnline = "Get_Mes"
    let blackBox = "Get_BB,\(dateFirst)"
    let blackBoxNumber = ",\(dateLast)"
    let blackBoxBreak = "BREAK"
    let getIMEI = "Get_IMEI\r\n"
    let configSet = "Set,KSPW:3:8002,KSRV:3:tcp.sokolmeteo.com,KPBM:1:30,KCNL:1:4,KBCH:1:0,"
    let configSetNext = "KPWD:3:beeline,KPAK:1:30,KPOR:3:8002,KAPI:3:m2m.beeline.ru"
    let configGet = "Get,B0E,B0M,B0G,B1E,B1M,B1G,B2E,B2M,B2G,"
    let configGetNext = "B3E,B3M,B3G,B4E,B4M,B4G,B5E,B5M,B5G,B6E,B6M,B6G,B7E,B7M,B7G"
    let valueNext = "\r\n"
}
