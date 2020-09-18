//
//  Common.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

var isNight = false
var code = "ru"

var arrayState: [String] = ["-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1"]
var arrayMeteo: [String] = ["-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1"]
var arrayStateConnect: [String] = ["-1", "-1", "-1", "-1"]

var QTIM = "-1"
var QGSM = "-1"
var TRAF = "-1"
var QGPS = "-1"
var QAZI = "-1"
var QPRO = "-1"
var QPOP = "-1"
var QBKN = "-1"
var QPAK = "-1"
var QBMT = "-1"
var QEVS = "-1"

var Upow = "-1"
var t = "-1"
var WD = "-1"
var WV = "-1"
var WM = "-1"
var PR = "-1"
var HM = "-1"
var RN = "-1"
var UV = "-1"
var UVI = "-1"
var L = "-1"
var LI = "-1"
var KS = "-1"
var RSSI = "-1"

var KAPI = "-1"
var KUSR = "-1"
var KPWD = "-1"
var KPIN = "-1"
var KSRV = "-1"
var KPOR = "-1"
var KSPW = "-1"
var KPAK = "-1"
var KPBM = "-1"
var KCNL = "-1"
var KBCH = "-1"


var QRCODE = ""
var kCBAdvDataManufacturerData = ""
var rrsiPink = 0
var peripheralName: [String] = []
var RSSIMainArray: [String] = []
var RSSIMainArrayRSSI: [String] = []
var nameDevice = ""
var nameDeviceT = ""
var RSSIMain = "0"
var warning = false
var checkQR = false
var checkPopQR = false
var mainPassword = ""
var errorWRN = false
var checkASA = false
var checkMode = false
var valH = ""
var valL = ""
var full = "-----"
var nothing = "-----"
var cnt = "-----"
var wmPar = "1"
var hidednCell = false
var temp : String?
var indexCount = -1

var dateLast: Int = 0
var dateFirst: Int = 0
