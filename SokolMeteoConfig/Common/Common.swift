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

var arrayState: [String] = ["...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "..."]
var arrayMeteo: [String] = ["...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "..."]
var arrayStateConnect: [String] = ["...", "...", "...", "...", "...", "...", "...", "..."]

var arrayBmvdU: [String] = ["...", "...", "...", "...", "...", "...", "...", "..."]
var arrayBmvdR: [String] = ["...", "...", "...", "...", "...", "...", "...", "..."]
var countBMVD = 0

var Access_Allowed = 0
var dataBoxAll: String = ""

var QTIM = "..."
var QGSM = "..."
var TRAF = "..."
var QGPS = "..."
var QAZI = "..."
var QPRO = "..."
var QPOP = "..."
var QBKN = "..."
var QPAK = "..."
var QBMT = "..."
var QEVS = "..."

var Upow = "..."
var t = "..."
var WD = "..."
var WV = "..."
var WM = "..."
var PR = "..."
var HM = "..."
var RN = "..."
var UV = "..."
var UVI = "..."
var L = "..."
var LI = "..."
var KS = "..."
var RSSI = "..."

var KAPI = "..."
var KUSR = "..."
var KPWD = "..."
var KPIN = "..."
var KSRV = "..."
var KPOR = "..."
var KSPW = "..."
var KPAK = "..."
var KPBM = "..."
var KCNL = "..."
var KBCH = "..."


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
var newPassword = ""
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
