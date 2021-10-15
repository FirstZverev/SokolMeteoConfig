//
//  ListAvailDevices.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 30.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RealmSwift
import CoreBluetooth
import RealmSwift

class ListAvailDevices: UIViewController, ConnectedMeteoDelegate {
    
    var log: StateController?
    let connectedMeteoVC = ConnectedMeteoController()
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: screenH / 12 + 5 , width: screenW, height: 35))
    var attributedTitle = NSAttributedString()
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    var peripherals = [CBPeripheral]()
    var peripheralsSearch = [CBPeripheral]()
    var manager: CBCentralManager? = nil
    var timer = Timer()
    var stringAll: String = ""
    var stringAllCountBlackBox = [""]
    var iter = false
    var parsedData:[String : AnyObject] = [:]
    var bluetoothPeripheralManager: CBPeripheralManager?
    var searchList = [String]()
    let generator = UIImpactFeedbackGenerator(style: .light)

    var viewAlphaStart : UIView = {
       let viewAlphaStart = UIView()
        viewAlphaStart.frame = CGRect(x: 0, y: screenH / 12 + 110, width: screenW, height: screenH - (screenH / 12 + 110))
        viewAlphaStart.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return viewAlphaStart
    }()
    lazy var demoConnect: UIButton = {
        let btnConnet = UIButton()
        btnConnet.backgroundColor = .purple
        btnConnet.translatesAutoresizingMaskIntoConstraints = false
        btnConnet.backgroundColor = UIColor(rgb: 0xBE449E)
        btnConnet.layer.cornerRadius = 22
        btnConnet.setTitle("Подключиться", for: .normal)
        btnConnet.titleLabel?.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        btnConnet.setTitleColor(.white, for: .normal)
        btnConnet.showsTouchWhenHighlighted = true
        btnConnet.setTitleColor(UIColor(rgb: 0xB64894), for: .highlighted)
        btnConnet.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        btnConnet.layer.shadowRadius = 6.0
        btnConnet.layer.shadowOpacity = 0.5
        btnConnet.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        btnConnet.addTarget(self, action: #selector(actionDemo), for: .touchUpInside)
        return btnConnet
    }()
    lazy var demoLabel: UILabel = {
        let demoLabel = UILabel()
        //    let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: screenW / 2, height: 60))
        demoLabel.textAlignment = .left
        demoLabel.text = "Sokol-M_Demo"
        demoLabel.textColor = .black
        demoLabel.translatesAutoresizingMaskIntoConstraints = false
        demoLabel.font = UIFont(name:"FuturaPT-Light", size: 24.0)
        return demoLabel
    }()
    
    lazy var alertView: CustomAlertWarning = {
        let alertView: CustomAlertWarning = CustomAlertWarning.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cancelLabel: UILabel = {
        let cancelLabel = UILabel()
        cancelLabel.text = "Отменить"
        cancelLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelLabel.textColor = .purple
        cancelLabel.clipsToBounds = false
        cancelLabel.isHidden = true
        cancelLabel.font = UIFont(name: "FuturaPT-Medium", size: 20)
        cancelLabel.layer.shadowColor = UIColor.white.cgColor
        cancelLabel.layer.shadowRadius = 5.0
        cancelLabel.layer.shadowOpacity = 0.7
        cancelLabel.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        return cancelLabel
    }()
    
    @objc func actionDemo() {
        Access_Allowed = 0
        mainPassword = ""
        nameDevice = "Sokol-M_DEMO"
        demoMode = true
        self.navigationController?.pushViewController(ConnectedMeteoController(), animated: true)
        
    }

    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .purple
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "FON")!)
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        img.alpha = 0.3
        img.frame = CGRect(x: 0, y: screenH - 260, width: 201, height: 207)
        return img
    }()
    
    lazy var activityIndicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .zero, type: .ballGridPulse, color: UIColor.purple)
        view.frame.size = CGSize(width: 50, height: 50)
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        return view
    }()
    lazy var activityIndicatorStart: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .zero, type: .ballGridPulse, color: UIColor.purple)
        view.frame.size = CGSize(width: 50, height: 50)
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        return view
    }()
    func buttonTap() {
        if reload != 6 {
            stringAll.removeAll()
        }
        peripheral(CBPeripheralForDisconnect, didDiscoverCharacteristicsFor: CBServiceForDisconnect, error: nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            if reload != 6 {
                stringAll = ""
            }
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func dataValueChange(peripheralCBCharacteristic: [Any],valuesString: [String]) {
        for i in 0...valuesString.count - 1 {
            guard let peripheral: CBPeripheral = peripheralCBCharacteristic[0] as? CBPeripheral,
                  let characteristic: CBCharacteristic = peripheralCBCharacteristic[1] as? CBCharacteristic else {return}
            peripheral.writeValue(Data(valuesString[i].utf8), for: characteristic, type: .withResponse)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        DispatchQueue.main.async { 
            CBPeripheralForDisconnect = peripheral
            CBServiceForDisconnect = service
            let valueAll = "PWD_USER,\(mainPassword)\r\n"
            let changePassword = "PWD_CHANGE_USER,\(newPassword)\r\n"
            let changePasswordService = "PWD_CHANGE_SERVICE,\(newPassword)\r\n"
            let valueAll1 = "Get_State"
            let valueOnline = "Get_Mes"
            let blackBox = "Get_BB,\(dateFirst)"
            let blackBoxBreak = "BREAK"
            let getIMEI = "Get_IMEI\r\n"
            let configGet = "Get,KSPW,KSRV,KPBM,KCNL,KPAK"
            let configGetNext = ",KAPI,KUSR,KPWD,KPIN,KPOR,KBCH"
            let getVersion = "Ver\r\n"
            let rebootBT = "REBOOT_BT\r\n"
            let configSet = "Set,KSPW:3:\(KSPW),KSRV:3:\(KSRV),KPBM:1:\(KPBM),KCNL:1:\(KCNL),KBCH:1:\(KBCH),KUSR:3:\(KUSR),"
            let configSetNext = "KPWD:3:\(KPWD),KPAK:1:\(KPAK),KPOR:3:\(KPOR),KAPI:3:\(KAPI),KPIN:3:\(KPIN)"
            
            let configGetBmvd = "Get,B0E,B0M,B1E,B1M,B2E,B2M,"
            let configGetBmvdNext = "B3E,B3M,B4E,B4M,B5E,B5M,B6E,B6M,B7E,B7M"
            let configSetBmvd = "Set,B\(selectBmvd)E:0:80,B\(selectBmvd)M:0:\(macAddress),QBKN:1:1"
            let configSetBmvdRemove = "Set,B\(selectBmvd)E:0:0,B\(selectBmvd)M:0:FFFFFFFFFFFF"
            let blackBoxNumber = ",\(dateLast)"
            let valueNext = "\r\n"
            
            guard let serviceCharacteristics = service.characteristics else {return}
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    switch reload {
                    case 0:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [valueAll])
                    case 1:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [valueAll1,valueNext])
                    case 2:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [valueOnline,valueNext])
                    case 3:
                        countStringBlackBox = 0
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [blackBox,blackBoxNumber,valueNext])
                    case 4: break
                    case 5: break
                    case 6:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [blackBoxBreak,valueNext])
                    case 7:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [configSet,configSetNext,valueNext])
                    case 8:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [configSetBmvdRemove,valueNext])
                    case 9:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [configSetBmvd,valueNext])
                    case 10:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [configGetBmvd,configGetBmvdNext,valueNext])
                    case 11:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [configGet,configGetNext,valueNext])
                    case 25:
                        //смена пароля пользовательского
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [changePassword])
                        mainPassword = newPassword
                    case 26:
                        //смена пароля сервисного
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [changePasswordService])
                        mainPassword = newPassword
                    case 27:
                        //имей
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [getIMEI])
                    case 28:
                        //version
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [getVersion])
                    case 29:
                        //version
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [rebootBT])
                    default:
                        print("Ожидание")
                    }
                }
            }
            reload = -1
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    let queue = DispatchQueue(label: "1",qos: .utility)
    let string: String = ""
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        queue.sync { [self] in
            peripheral.readRSSI()
            let rxData = characteristic.value
            if let rxData = rxData {
                let numberOfBytes = rxData.count
                var rxByteArray = [UInt8](repeating: 0, count: numberOfBytes)
                (rxData as NSData).getBytes(&rxByteArray, length: numberOfBytes)
                let string = String(data: Data(rxByteArray), encoding: .utf8)
                stringAll = stringAll + string!
                let result = stringAll.components(separatedBy: [":",";","=",",","\r","\n"])
                if blackBoxStart == true {
                    if string!.contains("\r\n") && string!.contains("Unknown command") != true && stringAll.contains("Begin Transmit") != true {
                        let fullString = stringAll.components(separatedBy: "\r\n")
                        var ab = result
                        if ab[0].count == 6 && ab[1].count == 6 {
                            ab[0].insert(".", at: ab[0].index(ab[0].startIndex, offsetBy: 2))
                            ab[0].insert(".", at: ab[0].index(ab[0].startIndex, offsetBy: 5))
                            
                            ab[1].insert(":", at: ab[1].index(ab[1].startIndex, offsetBy: 2))
                            ab[1].insert(":", at: ab[1].index(ab[1].startIndex, offsetBy: 5))
                            let a = "\(ab[0]) \(ab[1])"
                            let account = BoxModel()
                            account.id = countStringBlackBox
                            account.nameDevice = nameDevice
                            account.time = "\(stringTounixTime(dateString: a))"
                            account.allString = fullString[0]
                            if ab.contains("t") {
                                let indexOfPerson = ab.firstIndex{$0 == "t"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("t\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrt = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("WD") {
                                let indexOfPerson = ab.firstIndex{$0 == "WD"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("WD\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrWD = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("WV") {
                                let indexOfPerson = ab.firstIndex{$0 == "WV"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("WV\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrWV = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("WM") {
                                let indexOfPerson = ab.firstIndex{$0 == "WM"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("WM\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrWM = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("PR") {
                                let indexOfPerson = ab.firstIndex{$0 == "PR"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("PR\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrPR = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("HM") {
                                let indexOfPerson = ab.firstIndex{$0 == "HM"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("HM\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrHM = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("RN") {
                                let indexOfPerson = ab.firstIndex{$0 == "RN"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("RN\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrRN = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("UV") {
                                let indexOfPerson = ab.firstIndex{$0 == "UV"}
                                if ab.count > indexOfPerson! + 2 {
                                    guard let result = Double(ab[indexOfPerson! + 2]) else { return }
                                    print("UV \(result)")
                                    if verDevice >= 133 {
                                        account.parametrUV = "\(Double(result))"
                                    } else {
                                        account.parametrUV = "\(Double(result) / 100)"
                                    }
                                }
                            }
                            if ab.contains("UVI") {
                                let indexOfPerson = ab.firstIndex{$0 == "UVI"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("UVI\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrUVI = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("L") {
                                let indexOfPerson = ab.firstIndex{$0 == "L"}
                                if ab.count > indexOfPerson! + 2 {
                                    guard let result = Int(ab[indexOfPerson! + 2]) else { return }
                                    if verDevice >= 133 {
                                        account.parametrL = "\(result)"
                                    } else {
                                        account.parametrL = "\(result * 2)"
                                    }
                                }
                            }
                            if ab.contains("LI") {
                                let indexOfPerson = ab.firstIndex{$0 == "LI"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("LI\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrLI = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("Upow") {
                                let indexOfPerson = ab.firstIndex{$0 == "Upow"}
                                if ab.count > indexOfPerson! + 2 {
//                                print("Upow\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrUpow = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("Uext") {
                                let indexOfPerson = ab.firstIndex{$0 == "Uext"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("Uext\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrUext = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("KS") {
                                let indexOfPerson = ab.firstIndex{$0 == "KS"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("KS\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrKS = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("RSSI") {
                                let indexOfPerson = ab.firstIndex{$0 == "RSSI"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("RSSI\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrRSSI = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("TR") {
                                let indexOfPerson = ab.firstIndex{$0 == "TR"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("TR\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrTR = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            if ab.contains("EVS") {
                                let indexOfPerson = ab.firstIndex{$0 == "EVS"}
                                if ab.count > indexOfPerson! + 2 {
//                                    print("EVS\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                    account.parametrEVS = "\(ab[indexOfPerson! + 2])"
                                }
                            }
                            let realm: Realm  = {
                                return try! Realm()
                            }()
                            do {
                                let config = Realm.Configuration(
                                    schemaVersion: 2,
                                    
                                    migrationBlock: { migration, oldSchemaVersion in
                                        if (oldSchemaVersion < 2) {
                                        }
                                    })
                                Realm.Configuration.defaultConfiguration = config
                                try realm.write {
                                    realm.add(account)
                                }
                            } catch {
                                print("error getting xml string: \(error)")
                            }
                        }
                        countStringBlackBox += 1
                        DispatchQueue.main.async { [self] in
                            connectedMeteoVC.blackBoxVC.alertView.labelCountSave.text = "\(countStringBlackBox)"
                        }
                        stringAll.removeAll()
                    } else if string!.contains("Begin Transmit") {
                        stringAll.removeAll()
                    } else if string!.contains("Unknown command") {
                        stringAll.removeAll()
                    }
                    if result.contains("End Transmit") == true && result.contains("No DATA") != true {
                       connectedMeteoVC.blackBoxVC.alertView.CustomEnter.isEnabled = true
                        connectedMeteoVC.blackBoxVC.animateOut()
                        let blackBoxMeteoDataController = BlackBoxMeteoDataController()
                        blackBoxMeteoDataController.nameDeviceBlackBox = nameDevice
                        navigationController?.pushViewController(blackBoxMeteoDataController, animated: true)
                        connectedMeteoVC.blackBoxVC.alertView.CustomEnter.text("Обработка")
                        blackBoxStart = false
//                        connectedMeteoVC.blackBoxVC.alertView.CustomEnter.isEnabled = false
//                        dataBoxAll = "\(result)"
//                        stringAllCountBlackBox.removeAll()
//                        stringAllCountBlackBox = stringAll.components(separatedBy: "\r\n")
//                        for i in 1...stringAllCountBlackBox.count - 3 {
//                            var ab = stringAllCountBlackBox[i].components(separatedBy: [":",";","=",","])
//                            if ab[0] != "End Transmit" && ab[0].count == 6 && ab[1].count == 6 {
//                                ab[0].insert(".", at: ab[0].index(ab[0].startIndex, offsetBy: 2))
//                                ab[0].insert(".", at: ab[0].index(ab[0].startIndex, offsetBy: 5))
//
//                                ab[1].insert(":", at: ab[1].index(ab[1].startIndex, offsetBy: 2))
//                                ab[1].insert(":", at: ab[1].index(ab[1].startIndex, offsetBy: 5))
//                                let a = "\(ab[0]) \(ab[1])"
//                                let account = BoxModel()
//                                account.id = i
//                                account.nameDevice = nameDevice
//                                account.time = "\(stringTounixTime(dateString: a))"
//                                account.allString = stringAllCountBlackBox[i]
//                                if ab.contains("t") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "t"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("t\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrt = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("WD") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "WD"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("WD\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrWD = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("WV") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "WV"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("WV\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrWV = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("WM") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "WM"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("WM\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrWM = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("PR") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "PR"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("PR\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrPR = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("HM") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "HM"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("HM\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrHM = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("RN") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "RN"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("RN\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrRN = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("UV") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "UV"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("UV\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrUV = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("UVI") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "UVI"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("UVI\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrUVI = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("L") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "L"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("L\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrL = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("LI") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "LI"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("LI\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrLI = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("Upow") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "Upow"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("Upow\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrUpow = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("Uext") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "Uext"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("Uext\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrUext = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("KS") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "KS"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("KS\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrKS = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("RSSI") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "RSSI"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("RSSI\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrRSSI = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("TR") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "TR"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("TR\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrTR = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                if ab.contains("EVS") {
//                                    let indexOfPerson = ab.firstIndex{$0 == "EVS"}
//                                    if ab.count > indexOfPerson! + 2 {                            print("EVS\(i): \(ab[indexOfPerson! + 2])")
//                                        account.parametrEVS = "\(ab[indexOfPerson! + 2])"
//                                    }
//                                }
//                                let realm: Realm  = {
//                                   return try! Realm()
//                                }()
//                                do {
//                                    let config = Realm.Configuration(
//                                        schemaVersion: 0,
//
//                                        migrationBlock: { migration, oldSchemaVersion in
//                                            if (oldSchemaVersion < 1) {
//                                            }
//                                        })
//                                    Realm.Configuration.defaultConfiguration = config
//                                    print(Realm.Configuration.defaultConfiguration.fileURL!)
//                                        try realm.write {
//                                            realm.add(account)
//                                        }
//                                } catch {
//                                    print("error getting xml string: \(error)")
//                                }
//                            }
//                        }
////                        if result.contains("Unknown command") != true {
//                            if let viewControllers = navigationController?.viewControllers {
//                                for viewController in viewControllers {
//                                    if viewController.isKind(of: BlackBoxController.self) {
//                                        connectedMeteoVC.blackBoxVC.alertView.CustomEnter.isEnabled = true
//                                        connectedMeteoVC.blackBoxVC.animateOut()
//                                        let blackBoxMeteoDataController = BlackBoxMeteoDataController()
//                                        blackBoxMeteoDataController.nameDeviceBlackBox = nameDevice
//                                        navigationController?.pushViewController(blackBoxMeteoDataController, animated: true)
//                                    }
//                                }
//                            }
//                        }
//                        let indexOfPerson = result.firstIndex{$0 == ""}
                    }
                    if result.contains("No DATA") == true {
                        showToast(message: "Данных за этот период нет", seconds: 1.0)
                        connectedMeteoVC.blackBoxVC.alertView.CustomEnter.isEnabled = true
                        blackBoxStart = false
                        connectedMeteoVC.blackBoxVC.animateOut()
                    }
//                    if result.contains("Unknown command") == true {
//                        showToast(message: "Ошибка", seconds: 1.0)
//                        connectedMeteoVC.blackBoxVC.alertView.CustomEnter.isEnabled = true
//                        blackBoxStart = false
//                        connectedMeteoVC.blackBoxVC.animateOut()
//                    }
                } else {
                    countBMVD = 0
                    print(result)
                    if result.contains("Access_Denied") {
                        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                        connectedMeteoVC.setAlert()
                        connectedMeteoVC.animateIn()
                        Access_Allowed = 0
                    }
                    if result.contains("Access_Allowed") {
                        connectedMeteoVC.viewAlpha.isHidden = true
                        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        let indexOfPerson = result.firstIndex{$0 == "Access_Allowed"}
                        if result.count > indexOfPerson! + 2 {
                            Access_Allowed = Int(result[indexOfPerson! + 1])!
                            if Access_Allowed != 2 {
                                if let viewControllers = navigationController?.viewControllers {
                                    for viewController in viewControllers {
                                        if viewController.isKind(of: PasswordController.self) {
                                            if connectedMeteoVC.passwordVC.segmentedControl1.selectedSegmentIndex == 1 {
                                                navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                                                connectedMeteoVC.setAlert()
                                                connectedMeteoVC.animateIn()
                                            }
                                            connectedMeteoVC.passwordVC.updateViewAlpha()
                                        }
                                        if viewController.isKind(of: TabBarConfiguratorController.self) {
                                            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                                            connectedMeteoVC.setAlert()
                                            connectedMeteoVC.animateIn()
                                        }
                                        if viewController.isKind(of: BlackBoxController.self) {
                                            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                                            connectedMeteoVC.blackBoxVC.viewAlpha.isHidden = true
                                            connectedMeteoVC.blackBoxVC.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                                        }
                                    }
                                }
                            } else if Access_Allowed >= 1 {
                                if let viewControllers = navigationController?.viewControllers {
                                    for viewController in viewControllers {
                                        if viewController.isKind(of: TabBarConfiguratorController.self) {
                                            reload = 11
                                            buttonTap()
                                        }
                                        if viewController.isKind(of: PasswordController.self) {
                                            if connectedMeteoVC.passwordVC.segmentedControl1.selectedSegmentIndex == 2 {
                                                if Access_Allowed == 2 {
                                                    connectedMeteoVC.passwordVC.updateHash()
                                                } else {
                                                    connectedMeteoVC.passwordVC.updateDontHash()
                                                }
                                            } else {
                                                connectedMeteoVC.passwordVC.updateViewAlpha()
                                            }
                                        }
                                        if viewController.isKind(of: BlackBoxController.self) {
                                            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                                            connectedMeteoVC.blackBoxVC.viewAlpha.isHidden = true
                                            connectedMeteoVC.blackBoxVC.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if result.contains("QTIM") {
                        let indexOfPerson = result.firstIndex{$0 == "QTIM"}
                        if result.count > indexOfPerson! + 2 {
                            guard let a = Double(result[indexOfPerson! + 2]) else {return}
                            let date = Date(timeIntervalSince1970: a)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium
                            dateFormatter.dateStyle = DateFormatter.Style.short
                            dateFormatter.timeZone = .current
                            let localDate = dateFormatter.string(from: date)
                            arrayState[0] = "\(localDate)"
                            arrayStateConnect[0] = "\(localDate)"
                            arrayStateMain["QTIM"] = "\(localDate)"
                        }
                    }
                    if result.contains("QGSM") {
                        let indexOfPerson = result.firstIndex{$0 == "QGSM"}
                        if result.count > indexOfPerson! + 2 {
                            arrayStateMain["QGSM"] = "\(result[indexOfPerson! + 2])"
                            arrayState[1] = "\(result[indexOfPerson! + 2])"
                            arrayStateConnect[1] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QGPS") {
                        let indexOfPerson = result.firstIndex{$0 == "QGPS"}
                        if result.count > indexOfPerson! + 2 {
                            arrayStateMain["QGPS"] = "\(result[indexOfPerson! + 2])"

                            arrayState[2] = "\(result[indexOfPerson! + 2])"
                            arrayStateConnect[3] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QAZI") {
                        let indexOfPerson = result.firstIndex{$0 == "QAZI"}
                        if result.count > indexOfPerson! + 2 {
                            arrayStateMain["QAZI"] = "\(result[indexOfPerson! + 2])"

                            arrayState[3] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QPRO") {
                        let indexOfPerson = result.firstIndex{$0 == "QPRO"}
                        if result.count > indexOfPerson! + 2 {
                            arrayStateMain["QPRO"] = "\(result[indexOfPerson! + 2])"

                            arrayState[4] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QPOP") {
                        let indexOfPerson = result.firstIndex{$0 == "QPOP"}
                        if result.count > indexOfPerson! + 2 {
                            arrayStateMain["QPOP"] = "\(result[indexOfPerson! + 2])"

                            arrayState[5] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QBKN") {
                        let indexOfPerson = result.firstIndex{$0 == "QBKN"}
                        if result.count > indexOfPerson! + 2 {
                            arrayStateMain["QBKN"] = "\(result[indexOfPerson! + 2])"

                            arrayState[6] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QPAK") {
                        let indexOfPerson = result.firstIndex{$0 == "QPAK"}
                        if result.count > indexOfPerson! + 2 {
                            arrayStateMain["QPAK"] = "\(result[indexOfPerson! + 2])"

                            arrayState[7] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QBMT") {
                        let indexOfPerson = result.firstIndex{$0 == "QBMT"}
                        if result.count > indexOfPerson! + 2 {
                            arrayStateMain["QBMT"] = "\(result[indexOfPerson! + 2])"

                            arrayState[8] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("UBAT") {
                        let indexOfPerson = result.firstIndex{$0 == "UBAT"}
                        if result.count > indexOfPerson! + 2 {
                            arrayStateMain["UBAT"] = "\(result[indexOfPerson! + 2])"

                            arrayState[9] = "\(result[indexOfPerson! + 2])"
                            arrayStateConnect[5] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("UEXT") {
                        let indexOfPerson = result.firstIndex{$0 == "UEXT"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[10] = "\(result[indexOfPerson! + 2])"
                            arrayStateMain["UEXT"] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("KS") {
                        let indexOfPerson = result.firstIndex{$0 == "KS"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[11] = "\(result[indexOfPerson! + 2])"
                            arrayStateMain["KS"] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("RSSI") {
                        let indexOfPerson = result.firstIndex{$0 == "RSSI"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[12] = "\(result[indexOfPerson! + 2])"
                            arrayStateMain["RSSI"] = "\(result[indexOfPerson! + 2])"
                            arrayStateConnect[4] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("TRAF") {
                        let indexOfPerson = result.firstIndex{$0 == "TRAF"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[13] = "\(result[indexOfPerson! + 2])"
                            arrayStateMain["TRAF"] = "\(result[indexOfPerson! + 2])"
                            arrayStateConnect[2] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QEVS") {
                        let indexOfPerson = result.firstIndex{$0 == "QEVS"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[14] = "\(result[indexOfPerson! + 2])"
                            arrayStateMain["QEVS"] = "\(result[indexOfPerson! + 2])"
                            if let viewControllers = navigationController?.viewControllers {
                                for viewController in viewControllers {
                                    if viewController.isKind(of: TabBarController.self) {
                                        connectedMeteoVC.tabBarVC.searchVC.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                    
                    if result.contains("t") {
                        let indexOfPerson = result.firstIndex{$0 == "t"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[0] = "\(result[indexOfPerson! + 2]) °C"
                            arrayMeteoMain["t"] = "\(result[indexOfPerson! + 2]) °C"

                        }
                    }
                    if result.contains("WD") {
                        let indexOfPerson = result.firstIndex{$0 == "WD"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[1] = "\(result[indexOfPerson! + 2])"
                            arrayMeteoMain["WD"] = "\(result[indexOfPerson! + 2])"

                        }
                    }
                    if result.contains("WV") {
                        let indexOfPerson = result.firstIndex{$0 == "WV"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[2] = "\(result[indexOfPerson! + 2])"
                            arrayMeteoMain["WV"] = "\(result[indexOfPerson! + 2])"

                        }
                    }
                    if result.contains("WM") {
                        let indexOfPerson = result.firstIndex{$0 == "WM"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[3] = "\(result[indexOfPerson! + 2])"
                            arrayMeteoMain["WM"] = "\(result[indexOfPerson! + 2])"

                        }
                    }
                    if result.contains("PR") {
                        let indexOfPerson = result.firstIndex{$0 == "PR"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[4] = "\(result[indexOfPerson! + 2]) гПа"
                            arrayMeteoMain["PR"] = "\(result[indexOfPerson! + 2]) гПа"

                        }
                    }
                    if result.contains("HM") {
                        let indexOfPerson = result.firstIndex{$0 == "HM"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[5] = "\(result[indexOfPerson! + 2]) %"
                            arrayMeteoMain["HM"] = "\(result[indexOfPerson! + 2]) %"

                        }
                    }
                    if result.contains("RN") {
                        let indexOfPerson = result.firstIndex{$0 == "RN"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[6] = "\(result[indexOfPerson! + 2]) мм"
                            arrayMeteoMain["RN"] = "\(result[indexOfPerson! + 2]) мм"

                        }
                    }
                    if result.contains("UV") {
                        let indexOfPerson = result.firstIndex{$0 == "UV"}
                        if result.count > indexOfPerson! + 2 {
                            guard let result = Double(result[indexOfPerson! + 2]) else { return }
                            if verDevice >= 133 {
                                arrayMeteo[7] = "\(Double(result)) Вт/м2"
                                arrayMeteoMain["UV"] = "\(result) Вт/м2"
                            } else {
                                arrayMeteo[7] = "\(Double(result) / 100) Вт/м2"
                                arrayMeteoMain["UV"] = "\(Double(result) / 100) Вт/м2"
                            }
                        }
                    }
                    if result.contains("UVI") {
                        let indexOfPerson = result.firstIndex{$0 == "UVI"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[8] = "\(result[indexOfPerson! + 2]) Дж"
                            arrayMeteoMain["UVI"] = "\(result[indexOfPerson! + 2]) Дж"
                        }
                    }
                    if result.contains("L") {
                        let indexOfPerson = result.firstIndex{$0 == "L"}
                        if result.count > indexOfPerson! + 2 {
                            guard let result = Int(result[indexOfPerson! + 2]) else { return }
                            if verDevice >= 133 {
                                arrayMeteo[9] = "\(result) lux"
                                arrayMeteoMain["L"] = "\(result) lux"
                            } else {
                                arrayMeteo[9] = "\(result * 2) lux"
                                arrayMeteoMain["L"] = "\(result * 2) lux"
                            }
                        }
                    }
                    if result.contains("LI") {
                        let indexOfPerson = result.firstIndex{$0 == "LI"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteoMain["LI"] = "\(result[indexOfPerson! + 2]) Дж"
                            print(arrayMeteoMain)
                            arrayMeteo[10] = "\(result[indexOfPerson! + 2]) Дж"
                            if let viewControllers = navigationController?.viewControllers {
                                for viewController in viewControllers {
                                    if viewController.isKind(of: TabBarController.self) {
                                        connectedMeteoVC.tabBarVC.mainVC.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                    for i in 0...7 {
                        if result.contains("B\(i)E") {
                            let indexOfPerson = result.firstIndex{$0 == "B\(i)E"}
                            if result.count > indexOfPerson! + 2 {
                                if result[indexOfPerson! + 2] == "80" {
                                    arrayBmvdE[i] = "1"
                                } else {
                                    arrayBmvdE[i] = "0"
                                }
                            }
                        }
                        if result.contains("B\(i)M") {
                            let indexOfPerson = result.firstIndex{$0 == "B\(i)M"}
                            if result.count > indexOfPerson! + 2 {
                                arrayBmvdM[i] = "\(result[indexOfPerson! + 2])"
                                if i == 7 {
                                    connectedMeteoVC.tabarConfigVC.secondVC.configuratorBMVDSecondvc.tableView.reloadData()
                                    connectedMeteoVC.tabarConfigVC.secondVC.configuratorBMVDSecondvc.refreshControl.endRefreshing()
                                    connectedMeteoVC.tabarConfigVC.secondVC.configuratorBMVDSecondvc.viewAlpha.isHidden = true
                                }
                            }
                        }
                    }
                    
                    if result.contains("B\(selectBmvd)M") {
                        let indexOfPerson = result.firstIndex{$0 == "B\(selectBmvd)M"}
                        if result.count > indexOfPerson! + 2 {
                            connectedMeteoVC.tabarConfigVC.secondVC.configuratorBMVDSecondvc.viewAlpha.isHidden = true
                        }
                    }
                    countBMVD = 0
                    arrayBmvdCount.removeAll()
                    arrayCount.removeAll()
                    for i in 0...7 {
                        if result.contains("Ex\(i)U") {
                            let indexOfPerson = result.firstIndex{$0 == "Ex\(i)U"}
                            if result.count > indexOfPerson! + 2 {
                                arrayBmvdU[countBMVD] = "\(result[indexOfPerson! + 2])"
                            }
                            for j in 0...7 {
                                if result.contains("Ex\(i)T\(j)") {
                                    let indexOfPerson = result.firstIndex{$0 == "Ex\(i)T\(j)"}
                                    if result.count > indexOfPerson! + 2 {
                                        let a = (result[indexOfPerson! + 2] as NSString).integerValue
                                        arrayBmvdCount["\(i)T\(j)"] = "\(a)"
                                    }
                                }
                                if result.contains("Ex\(i)H\(j)") {
                                    let indexOfPerson = result.firstIndex{$0 == "Ex\(i)H\(j)"}
                                    if result.count > indexOfPerson! + 2 {
                                        arrayBmvdCount["\(i)H\(j)"] = "\(result[indexOfPerson! + 2])"
                                    }
                                }
                                if result.contains("Ex\(i)h\(j)") {
                                    let indexOfPerson = result.firstIndex{$0 == "Ex\(i)h\(j)"}
                                    if result.count > indexOfPerson! + 2 {
                                        arrayBmvdCount["\(i)h\(j)"] = "\(result[indexOfPerson! + 2])"
                                    }
                                }
                                if result.contains("Ex\(i)t\(j)") {
                                    let indexOfPerson = result.firstIndex{$0 == "Ex\(i)t\(j)"}
                                    if result.count > indexOfPerson! + 2 {
                                        arrayBmvdCount["\(i)t\(j)"] = "\(result[indexOfPerson! + 2])"
                                    }
                                }
                                if result.contains("Ex\(i)l\(j)") {
                                    let indexOfPerson = result.firstIndex{$0 == "Ex\(i)l\(j)"}
                                    if result.count > indexOfPerson! + 2 {
                                        arrayBmvdCount["\(i)l\(j)"] = "\(result[indexOfPerson! + 2])"
                                    }
                                }
                            }
                        }
                        if result.contains("Ex\(i)R") {
                            let indexOfPerson = result.firstIndex{$0 == "Ex\(i)R"}
                            if result.count > indexOfPerson! + 2 {
                                arrayBmvdR[countBMVD] = "\(result[indexOfPerson! + 2])"
                            }
                            countBMVD += 1
                            arrayCount.append(i)
                            
                        }
                    }
                    
                    if result.contains("KAPI") {
                        let indexOfPerson = result.firstIndex{$0 == "KAPI"}
                        if result.count > indexOfPerson! + 2 {
                            KAPI = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("KUSR") {
                        let indexOfPerson = result.firstIndex{$0 == "KUSR"}
                        if result.count > indexOfPerson! + 2 {
                            KUSR = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("KPWD") {
                        let indexOfPerson = result.firstIndex{$0 == "KPWD"}
                        if result.count > indexOfPerson! + 2 {
                            KPWD = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("KPIN") {
                        let indexOfPerson = result.firstIndex{$0 == "KPIN"}
                        if result.count > indexOfPerson! + 2 {
                            KPIN = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("KSRV") {
                        let indexOfPerson = result.firstIndex{$0 == "KSRV"}
                        if result.count > indexOfPerson! + 2 {
                            KSRV = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("KPOR") {
                        let indexOfPerson = result.firstIndex{$0 == "KPOR"}
                        if result.count > indexOfPerson! + 2 {
                            KPOR = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("KSPW") {
                        let indexOfPerson = result.firstIndex{$0 == "KSPW"}
                        if result.count > indexOfPerson! + 2 {
                            KSPW = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("KPAK") {
                        let indexOfPerson = result.firstIndex{$0 == "KPAK"}
                        if result.count > indexOfPerson! + 2 {
                            KPAK = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("KPBM") {
                        let indexOfPerson = result.firstIndex{$0 == "KPBM"}
                        if result.count > indexOfPerson! + 2 {
                            KPBM = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("KCNL") {
                        let indexOfPerson = result.firstIndex{$0 == "KCNL"}
                        if result.count > indexOfPerson! + 2 {
                            KCNL = Channels(int: Int(result[indexOfPerson! + 2])!).channelsNumber()
                        }
                    }
                    if result.contains("KBCH") {
                        let indexOfPerson = result.firstIndex{$0 == "KBCH"}
                        if result.count > indexOfPerson! + 2 {
                            KBCH = "\(result[indexOfPerson! + 2])"
                            connectedMeteoVC.tabarConfigVC.firstVC.updateInterface()
                            connectedMeteoVC.tabarConfigVC.firstVC.viewAlpha.isHidden = true
                        }
                    }
                    
                    if result.contains("APO") {
                        print("APO 0")
                    }
                    if result.contains("ADO") {
                        errorWRN = false
                        print("ADO 0")
                    }
                    if result.contains("WRN") {
                        print("WRN 1")
                        
                    }
                    
                    if result.contains("WRN") {
                        errorWRN = true
                    }
                    if result.contains("ASA") {
                        checkASA = true
                    }
                    if result.contains("AWO") {
                        checkMode = true
                    }
                    if result.contains("Ver") {
                        let indexOfPerson = result.firstIndex{$0 == "Ver"}
                        if result.count > indexOfPerson! + 1 {
                            print(result[indexOfPerson! + 1])
                            connectedMeteoVC.deviceNameLabel.text = "\(nameDevice.uppercased())" + " (FW: \(result[indexOfPerson! + 1]))"
                            let sum = result[indexOfPerson! + 1].replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
                            connectedMeteoVC.viewAlpha.isHidden = true
                            guard let intSum = Int(sum) else { return }
                            verDevice = intSum
                        }
                    }
                    if result.contains("IMEI") {
                        let indexOfPerson = result.firstIndex{$0 == "IMEI"}
                        if result.count > indexOfPerson! + 1 {
                            if result[indexOfPerson! + 1] != "Not access" {
                                realmSave(nameDevice: nameDevice, imei: result[indexOfPerson! + 1])
                            }
                        }
                    }
                }
            }
        }
    }
    fileprivate func realmSave(nameDevice: String, imei: String) {
        do {
            let config = Realm.Configuration(
                schemaVersion: 2,
                
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 2) {
                    }
                })
            Realm.Configuration.defaultConfiguration = config
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            
            let realm: Realm  = {
                return try! Realm()
            }()
            
            let account = DeviceNameModel()
            account.nameDevice = nameDevice
            account.IMEIDevice = imei
            
            let realmCheck = realm.objects(DeviceNameModel.self).filter("nameDevice = %@", account.nameDevice!)
            if realmCheck.count == 0 {
                try realm.write {
                    realm.add(account)
                }
            } else {
                try! realm.write {
                    realmCheck.setValue(account.IMEIDevice, forKey: "IMEIDevice")
                }
            }
            print(realmCheck)
        } catch {
            print("error getting xml string: \(error)")
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("error: \(error)")
            return
        }
        
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
        
    }
    private func centralManager(
        central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: NSError?) {
        print("disconect")
        scanBLEDevices()
        
    }
    
    var tableViewData = [cellDataPeripheral]()
    weak var tableView: UITableView!
    
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenW + 20, height: 100)
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: 30, width: Int(screenW - 70), height: 40))
        text.text = "Type of bluetooth sensor"
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: 19.0)
        return text
    }()
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        backView.hero.id = "backView"
        return backView
    }()
    
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(demoConnect)
        self.view.addSubview(demoLabel)
        NSLayoutConstraint.activate([
            demoConnect.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 + searchBar.bounds.height + 20),
            demoConnect.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            demoConnect.heightAnchor.constraint(equalToConstant: 44),
            demoConnect.widthAnchor.constraint(equalToConstant: 140),
            
            demoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 + searchBar.bounds.height + 20),
            demoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            demoLabel.heightAnchor.constraint(equalToConstant: 44),
            demoLabel.widthAnchor.constraint(equalToConstant: screenW / 2)
        ])
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 + searchBar.bounds.height + 80),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1),
        ])
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.isHidden = true
        tableView.alpha = 0.0
        self.tableView = tableView
        tableView.backgroundColor = .clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate lazy var hamburger: UIImageView = {
        let hamburger = UIImageView(image: UIImage(named: "img")!)
        hamburger.image = hamburger.image!.withRenderingMode(.alwaysTemplate)
        
        return hamburger
    }()
    
    
    fileprivate func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(DevicesListCellHeder.self, forCellReuseIdentifier: "DevicesListCellHeder")
        self.tableView.register(DevicesListCellMain.self, forCellReuseIdentifier: "DevicesListCellMain")
        self.tableView.register(DevicesListCell.self, forCellReuseIdentifier: "DevicesListCell")
    }
    @objc func refresh(sender:AnyObject) {
        searchBar.text = ""
        timer.invalidate()
        self.searchBar.endEditing(true)
        self.view.isUserInteractionEnabled = true
        peripherals.removeAll()
        RSSIMainArray.removeAll()
        rrsiPink = 0
        manager?.stopScan()
        tableViewData.removeAll()
        tableViewData.append(cellDataPeripheral(opened: false, title: "123", sectionData: ["123"]))
        tableViewData.insert(cellDataPeripheral(opened: false, title: "1234", sectionData: ["1234"]), at: 0)
        RSSIMainArray.append("2")
        RSSIMainArray.insert("1", at: 0)
        searchList.removeAll()
        searching = false
        searchBar.text = ""
        peripheralName.removeAll()
        if hidednCell == false {
            tableView.reloadData()
        }
        scanBLEDevices()
        startActivityIndicator()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectedMeteoVC.delegate = self
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.keyboardType = UIKeyboardType.decimalPad
        view.addSubview(searchBar)
        viewShow()
        manager = CBCentralManager ( delegate : self , queue : nil , options : nil )
        stringAll = ""
        registerTableView()
        setupTheme()
        view.addSubview(cancelLabel)
        
        cancelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 45).isActive = true
        
        cancelLabel.addTapGesture { [self] in
            print("Stop")
            self.navigationController?.popViewController(animated: true)
            
        }
        let customNavigationBar = createCustomNavigationBar(title: "СПИСОК ДОСТУПНЫХ МЕТЕОСТАНЦИЙ", fontSize: screenW / 22)
        self.hero.isEnabled = true
        customNavigationBar.hero.id = "ConnectToMeteo"
        backView.addTapGesture { self.popVC() }
        view.sv(
            customNavigationBar
        )
        view.addSubview(backView)
        
        viewAlpha.isHidden = true
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.center = viewAlpha.center
        view.addSubview(viewAlpha)
        
        viewAlphaStart.isHidden = true
        viewAlphaStart.addSubview(activityIndicatorStart)
        activityIndicatorStart.center = CGPoint(x: screenW / 2, y: screenH / 2 -  (screenH / 12 + 110))
        view.addSubview(viewAlphaStart)
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    func startActivityIndicator() {
        self.viewAlphaStart.isHidden = false
        self.cancelLabel.isHidden = false
        cancelLabel.superview?.bringSubviewToFront(cancelLabel)
        activityIndicatorStart.startAnimating()
        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.tableView.alpha = 0.0
        }) { [self] (_) in
            self.view.isUserInteractionEnabled = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {

    }
    override func viewWillAppear(_ animated: Bool) {
        startActivityIndicator()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        self.viewAlphaStart.isHidden = true
        self.cancelLabel.isHidden = true
        tableView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.tableView.alpha = 1.0
        }) { [self] (_) in
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.view.isUserInteractionEnabled = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if CBPeripheralForDisconnect != nil {
            manager?.cancelPeripheralConnection(CBPeripheralForDisconnect)
        }
        demoMode = false
        print(viewDidAppear)
        searchBar.text = ""
        timer.invalidate()
        self.searchBar.endEditing(true)
        self.view.isUserInteractionEnabled = true
        peripherals.removeAll()
        RSSIMainArray.removeAll()
        rrsiPink = 0
        manager?.stopScan()
        tableViewData.removeAll()
        tableViewData.append(cellDataPeripheral(opened: false, title: "123", sectionData: ["123"]))
        tableViewData.insert(cellDataPeripheral(opened: false, title: "1234", sectionData: ["1234"]), at: 0)
        RSSIMainArray.append("2")
        RSSIMainArray.insert("1", at: 0)
        searchList.removeAll()
        searching = false
        searchBar.text = ""
        peripheralName.removeAll()
        if hidednCell == false {
            tableView.reloadData()
        }
        scanBLEDevices()
    }
    
    func scanBLEDevices() {
        peripherals.removeAll()
        manager?.scanForPeripherals(withServices: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if QRCODE != "" {
                if checkPopQR == false {
                    self.timer.invalidate()
                    self.navigationController?.popViewController(animated: true)
                    checkPopQR = true
                }
            }
            self.view.isUserInteractionEnabled = true
        }
    }
    func stopScanForBLEDevices() {
        manager?.stopScan()
        print("Stop")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        peripherals.removeAll()
        RSSIMainArray.removeAll()
        rrsiPink = 0
        manager?.stopScan()
        tableViewData.removeAll()
        searchList.removeAll()
        peripheralName.removeAll()
        if QRCODE == ""{
            if tableViewData.count != 0 {
                tableView.reloadData()
            }
        }
    }
    
    @objc func backTransition() {
        self.generator.impactOccurred()
        self.navigationController?.popViewController(animated: true)
    }
    private func viewShow() {
        target(forAction: #selector(backTransition), withSender: UIControl.Event.touchUpInside)
        bgImage.tintColor = .black
        view.addSubview(bgImage)
        activityIndicator.startAnimating()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    var searching = false
    var searchedCountry = [String]()
    var aaa = [String]()
    let label = UILabel()
    fileprivate func setupTheme() {
        view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
        themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
        MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        searchBar.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        searchBar.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
        backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        
        if isNight {
            searchBar.textColor = .white
        } else {
            searchBar.textColor = .black
        }
    }
}
extension ListAvailDevices: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            manager?.scanForPeripherals(withServices: nil, options: nil)
            searching = false
            searchBar.text = ""
        }
        print(searchText)
        searchList = peripheralName.filter({$0.lowercased().contains(searchText)})
        print("searchList: \(searchList)")
        manager?.stopScan()
        searching = true
        tableView.reloadData()
        if searchText == "" {
            searchBarCancelButtonClicked(searchBar)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        manager?.scanForPeripherals(withServices: nil, options: nil)
        searching = false
        searchBar.text = ""
        self.view.endEditing(true)
        tableView.reloadData()
        
    }
    
}
