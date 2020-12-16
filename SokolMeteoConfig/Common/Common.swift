//
//  Common.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

var idSession = ""

var devicesList: [DataDevices] = []
var devicesParametrsList: [DeviceListResult] = []
var selectItem: Int?

var isNight = false
var code = "ru"

var arrayState: [String] = ["...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "..."]
var arrayMeteo: [String] = ["...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "..."]

var arrayMeteoMain: [String : String] = ["t" : "", "WD" : "", "WV" : "", "WM" : "", "PR" : "", "HM" : "", "RN" : "", "UV" : "", "UVI" : "", "L" : "", "LI" : "",]
var arrayStateMain: [String : String] = ["QTIM" : "", "QGSM" : "", "QGPS" : "", "QAZI" : "", "QPRO" : "", "QPOP" : "", "QBKN" : "", "QPAK" : "", "QBMT" : "", "UBAT" : "", "UEXT" : "", "KS" : "", "RSSI" : "", "TRAF" : "", "QEVS" : "",]

var arrayStateConnect: [String] = ["0", "0", "0", "0", "0", "0", "0", "0"]

var arrayBmvdU: [String] = ["...", "...", "...", "...", "...", "...", "...", "..."]
var arrayBmvdR: [String] = ["...", "...", "...", "...", "...", "...", "...", "..."]
var countBMVD = 0

var arrayBmvdE: [String] = ["0", "0", "0", "0", "0", "0", "0", "0"]
var arrayBmvdM: [String] = ["FFFFFFFFFFFF", "FFFFFFFFFFFF", "FFFFFFFFFFFF", "FFFFFFFFFFFF", "FFFFFFFFFFFF", "FFFFFFFFFFFF", "FFFFFFFFFFFF", "FFFFFFFFFFFF"]
var arrayBmvdCount: [String: String] = [:]
var arrayCount: [Int] = []



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
var countStringBlackBox: Int = 0

var dateLast: Int = 0
var dateFirst: Int = 0
var setPasswordCheak = -1

func unixTimetoStringOnlyDate(unixTime: Int) -> String {
    let unixtimeReal = unixTime / 1000
    let date = Date(timeIntervalSince1970: TimeInterval(unixtimeReal))
    let dateFormatter = DateFormatter()
//    dateFormatter.timeStyle = DateFormatter.Style.none
//    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.dateFormat = "dd.MM.yyyy"
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}
func unixTimetoString(unixTime: Int) -> String {
    let unixtimeReal = unixTime / 1000
    let date = Date(timeIntervalSince1970: TimeInterval(unixtimeReal))
    let dateFormatter = DateFormatter()
//    dateFormatter.timeStyle = DateFormatter.Style.medium
//    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.dateFormat = "dd.MM.yy HH:mm:ss"
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    let localDateMain = String(localDate.dropFirst(9))
    return localDateMain
}

func base64Encoded(email: String, password: String) -> String {
    let str = "\(email):\(password)"
    print("Original: \(str)")

    let utf8str = str.data(using: .utf8)

    if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
        return base64Encoded
    }
    return ""
}

func stringTounixTime(dateString: String) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yy HH:mm:ss"
//    dateFormatter.timeStyle = DateFormatter.Style.medium
//    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.timeZone = .current
    let date = dateFormatter.date(from: dateString)!
    let unixtime = date.timeIntervalSince1970
    return Int(unixtime)
}
func stringTounixTimeOnlyData(dateString: String) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
//    dateFormatter.timeStyle = DateFormatter.Style.medium
//    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.timeZone = .current
    let date = dateFormatter.date(from: dateString)!
    let unixtime = date.timeIntervalSince1970
    return Int(unixtime)
}

func unixTimeStringtoStringOnlyDate(unixTime: String) -> String {
    guard let unixtimeReal = Int(unixTime) else {return "error"}
    let date = Date(timeIntervalSince1970: TimeInterval(unixtimeReal))
    let dateFormatter = DateFormatter()
//    dateFormatter.timeStyle = DateFormatter.Style.none
//    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.dateFormat = "dd.MM.yy"
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}
func unixTimeStringtoStringFull(unixTime: String) -> String {
    guard let unixtimeReal = Int(unixTime) else {return "error"}
    let date = Date(timeIntervalSince1970: TimeInterval(unixtimeReal))
    let dateFormatter = DateFormatter()
//    dateFormatter.timeStyle = DateFormatter.Style.short
//    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.dateFormat = "dd.MM.yy HH:mm"
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}
func unixTimeStringtoStringOnlyHour(unixTime: String) -> String {
    guard let unixtimeReal = Int(unixTime) else {return "error"}
    let date = Date(timeIntervalSince1970: TimeInterval(unixtimeReal))
    let dateFormatter = DateFormatter()
//    dateFormatter.timeStyle = DateFormatter.Style.short
//    dateFormatter.dateStyle = DateFormatter.Style.none
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}
func unixTimeStringtoStringOnlySecond(unixTime: String) -> String {
    guard let unixtimeReal = Int(unixTime) else {return "error"}
    let date = Date(timeIntervalSince1970: TimeInterval(unixtimeReal))
    let dateFormatter = DateFormatter()
//    dateFormatter.timeStyle = DateFormatter.Style.medium
//    dateFormatter.dateStyle = DateFormatter.Style.none
    dateFormatter.dateFormat = "HH:mm:ss"
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}

func unixTimetoStringOnlyHour(unixTime: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
    let dateFormatter = DateFormatter()
//    dateFormatter.timeStyle = DateFormatter.Style.short
//    dateFormatter.dateStyle = DateFormatter.Style.none
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}

func unixTimeInttoStringOnlyDate(unixTime: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
    let dateFormatter = DateFormatter()
//    dateFormatter.timeStyle = DateFormatter.Style.none
//    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.dateFormat = "dd.MM.yy"
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}

var blackBoxStart = false
