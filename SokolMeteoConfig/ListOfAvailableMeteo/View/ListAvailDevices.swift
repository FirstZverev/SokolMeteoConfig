//
//  ListAvailDevices.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 30.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import CoreBluetooth
import NVActivityIndicatorView
import RealmSwift

struct cellDataDU {
    var opened = Bool()
    var title = String()
    var sectionData = [String()]
}

var a : CBPeripheral!
var b : CBService!

//var rrsiPink = 0
//var kCBAdvDataManufacturerData = ""
class DevicesDUController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, ConnectedMeteoDelegate {
    
    var log: StateController?
    let connectedMeteoVC = ConnectedMeteoController()
    func abc() {
        print("StateControllerDelegate")
    }
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
    
    var delegate: MainDelegate?

    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: screenH / 12 + 5 , width: screenW, height: 35))
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .purple
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    var attributedTitle = NSAttributedString()
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    var peripherals = [CBPeripheral]()
    var peripheralsSearch = [CBPeripheral]()
    var manager: CBCentralManager? = nil
    var timer = Timer()
    var stringAll: String = ""
    var stringAllCountBlackBox = 0
    var iter = false
    var parsedData:[String : AnyObject] = [:]
    var bluetoothPeripheralManager: CBPeripheralManager?
    var searchList = [String]()
    let generator = UIImpactFeedbackGenerator(style: .light)

    func centralManagerDidUpdateState (_ central : CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            let peripheralsArray = Array(peripherals)
            print(peripheralsArray)
            print("ON Работает.")
        }
        else {
            if #available(iOS 13.0, *) {
                switch central.authorization {
                case .allowedAlways: print("allowedAlways")
                case .denied:
                    let alert = UIAlertController(title: "У вас запрещен доступ к Bluetooth", message: "Для дальнейшей работы необходимо разрешить работу с Bluetooth", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Настройки", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                            print("default")
                            self.navigationController?.popViewController(animated: true)
                            self.view.subviews.forEach({ $0.removeFromSuperview() })
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            fatalError()
                        }}))
                    self.present(alert, animated: true, completion: nil)
                case .restricted:print("restricted")
                case .notDetermined:print("notDetermined")
                @unknown default:
                    print("")
                }
            } else {
                // Fallback on earlier versions
            }
//                        UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//            UIApplication.shared.open(URL(string: "App-prefs:Bluetooth")!)

            print("Bluetooth OFF.")
            let alert = UIAlertController(title: "Bluetooth выключен", message: "Для дальнейшей работы необходимо включить Bluetooth", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Настройки", style: .default, handler: { action in
                switch action.style{
                case .default:
                    UIApplication.shared.open(URL(string: "App-prefs:Bluetooth")!)
                    print("default")
                    self.navigationController?.popViewController(animated: true)
                    self.view.subviews.forEach({ $0.removeFromSuperview() })
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                @unknown default:
                    fatalError()
                }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let key = "kCBAdvDataLocalName"
        print("advertisementData: \(advertisementData)")
        if advertisementData["kCBAdvDataLocalName"] as? String != nil {
            let nameDevicesOps = (advertisementData["kCBAdvDataLocalName"] as? String)?.components(separatedBy: ["_"])
            if nameDevicesOps?[0] == "Sokol-M" && nameDevicesOps?[1] != "UPDATE" {
                print("Нашлось")
                if QRCODE == "" {
                    if(!peripherals.contains(peripheral)) {
                        print(RSSI)
                        if RSSI != 127{
                            let orderNum: NSNumber? = RSSI
                            let orderNumberInt  = orderNum?.intValue
                            if -71 < orderNumberInt! {
                                rrsiPink = rrsiPink + 1
                                print("rrsiPink:\(rrsiPink) \(orderNumberInt!)")
                                peripherals.insert(peripheral, at: rrsiPink - 1)
                                peripheralName.insert(advertisementData["kCBAdvDataLocalName"] as! String, at: rrsiPink - 1)
                                tableViewData.insert(cellDataDU(opened: false, title: "\(advertisementData["kCBAdvDataLocalName"] as! String)", sectionData: ["\(advertisementData["kCBAdvDataLocalName"] as! String)"]), at: rrsiPink)
                                print("RSSIName: \(advertisementData["kCBAdvDataLocalName"] as! String) and  RSSI: \(RSSI)")
                                RSSIMainArray.insert("\(RSSI)", at: rrsiPink)
                                stopActivityIndicator()
                                tableView.reloadData()
                            } else {
                                peripherals.append(peripheral)
                                peripheralName.append(advertisementData["kCBAdvDataLocalName"] as! String)
                                print("RSSIName1: \(advertisementData["kCBAdvDataLocalName"] as! String) and  RSSI: \(RSSI)")
                                tableViewData.append(cellDataDU(opened: false, title: "\(advertisementData["kCBAdvDataLocalName"] as! String)", sectionData: ["\(advertisementData["kCBAdvDataLocalName"] as! String)"]))
                                RSSIMainArray.append("\(RSSI)")
                                stopActivityIndicator()
                                tableView.reloadData()
                                if let manufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data {
                                    assert(manufacturerData.count >= 7)
                                    let nodeID = manufacturerData[2]
                                    print(String(format: "%02X", nodeID)) //->FE
                                    
                                    let state = UInt16(manufacturerData[3]) + UInt16(manufacturerData[4]) << 8
                                    let string34 = "\(String(format: "%04X", state))"
                                    print(string34) //->000D
                                    let result34 = UInt16(strtoul("0x\(string34)", nil, 16)) //уровень
                                    print(result34) //->000D
                                    //                                    adveLvl.append(String(result34))
                                    //c6f - is the sensor tag battery voltage
                                    //Constructing 2-byte data as big endian (as shown in the Java code)
                                    let batteryVoltage = UInt16(manufacturerData[5])
                                    let string5 = "\(String(format: "%02X", batteryVoltage))"
                                    print(string5) //->000D
                                    _ = UInt16(strtoul("0x\(string5)", nil, 16)) //напряжение
                                    //                                    var abn: String = String(result5)
                                    //                                    abn.insert(".", at: abn.index(abn.startIndex, offsetBy: 1))
                                    //                                    print(abn) //->000D
                                    //                                    adveVat.append(String(result5))
                                    
                                    //32- is the BLE packet counter.
                                    let packetCounter = manufacturerData[6]
                                    let string6 = "\(String(format: "%02X", packetCounter))"
                                    print(string6) //->000D
                                    let result6 = UInt16(strtoul("0x\(string6)", nil, 16)) //температура
                                    print(result6)
                                    //                                    adveTemp.append(String(result6))
                                    if manufacturerData.count >= 7 { return }
                                    let versionCounter = manufacturerData[7]
                                    let string7 = "\(String(format: "%02X", versionCounter))"
                                    print(string7) //->000D
                                    let result7 = UInt16(strtoul("0x\(string7)", nil, 16)) //весрия
                                    var abn7: String = String(result7)
                                    abn7.insert(".", at: abn7.index(abn7.startIndex, offsetBy: 1))
                                    //                                    abn7.insert(".", at: abn7.index(abn7.startIndex, offsetBy: 3))
                                    print(abn7)
                                    //                                    adveFW.append(String(abn7))
                                    
                                } else {
                                    //                                    adveLvl.append("...")
                                    //                                    adveVat.append("...")
                                    //                                    adveTemp.append("...")
                                    //                                    adveFW.append("...")
                                }
                            }
                            tableView.reloadData()
                            
                        }
                    } else {
                        if RSSI != 127{
                            print("Снова RSSIName: \(advertisementData["kCBAdvDataLocalName"] as! String) and  RSSI: \(RSSI)")
                            if let i = peripherals.firstIndex(of: peripheral) {
                                RSSIMainArray[i] = "\(RSSI)"
                            }
                            tableView.reloadData()

                        }
                    }
                } else {
                    let abc = advertisementData[key] as? [CBUUID]
                    guard let uniqueID = abc?.first?.uuidString else { return }
                    _ = uniqueID.components(separatedBy: ["-"])
                    if(!peripherals.contains(peripheral)) {
                        if peripheral.name! == "DU_\(QRCODE)" {
                            nameDevice = ""
                            print("YEEEES \(advertisementData["kCBAdvDataLocalName"] as! String)")
//                            temp = nil
                            self.activityIndicator.startAnimating()
                            self.view.addSubview(self.viewAlpha)
                            self.cancelLabel.superview?.bringSubviewToFront(self.cancelLabel)
                            self.cancelLabel.isHidden = false
//                            zeroTwo = 0
//                            zero = 0
//                            countNot = 0
                            self.manager?.connect(peripheral, options: nil)
//                            self.view.isUserInteractionEnabled = false
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                            self.manager?.stopScan()
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                                if self.navigationController != nil {
//                                    navController.pushViewController(DeviceDUBleController(), animated: true)
                                    QRCODE = ""
                                }
                                print("Connected to " +  peripheral.name!)
                                self.viewAlpha.removeFromSuperview()
                                self.cancelLabel.isHidden = true
                            })
                        }
                    }
                }
                tableView.reloadData()
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        RSSIMain = "\(RSSI)"
    }
    func buttonTap() {
        if reload != 6 {
            stringAll.removeAll()
        }
        peripheral(a, didDiscoverCharacteristicsFor: b, error: nil)
        print("Password ENTER")
    }
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if let navController = self.navigationController {
            Access_Allowed = 0
            navController.pushViewController(self.connectedMeteoVC, animated: true)
        }
        self.viewAlpha.removeFromSuperview()
        self.cancelLabel.isHidden = true
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        timer =  Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (timer) in
//            peripheral.discoverServices(nil)
            if peripheral.state == CBPeripheralState.connected {
                print("connectedP")
                checkQR = true
            }
            if peripheral.state == CBPeripheralState.disconnected {
                print("disconnectedP")
                if warning == true{
                    timer.invalidate()
                    self.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    timer.invalidate()
                    self.setAlert()
                    self.animateIn()
//                    self.present(alert, animated: true, completion: nil)
                }
                warning = false
            }
            if peripheral.state == CBPeripheralState.connecting {
                print("connectingP")
            }
            if peripheral.state == CBPeripheralState.disconnecting {
                print("disconnectingP")
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            if reload != 6 {
                stringAll = ""
            }
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        DispatchQueue.main.async { 
            a = peripheral
            b = service
            let valueAll = "PWD_USER,\(mainPassword)\r\n"
            let changePassword = "PWD_CHANGE_USER,\(newPassword)\r\n"
            let changePasswordService = "PWD_CHANGE_SERVICE,\(newPassword)\r\n"
            let valueAll1 = "Get_State"
            let valueOnline = "Get_Mes"
            let blackBox = "Get_BB,\(dateFirst)"
            let blackBoxBreak = "BREAK"
            let getIMEI = "Get_IMEI\r\n"
            let configSet = "Set,KSPW:3:8002,KSRV:3:tcp.sokolmeteo.com,KPBM:1:30,KCNL:1:4,KBCH:1:0,"
            let configSetNext = "KPWD:3:beeline,KPAK:1:30,KPOR:3:8002,KAPI:3:m2m.beeline.ru"
            let configGet = "Get,B0E,B0M,B0G,B1E,B1M,B1G,B2E,B2M,B2G,"
            let configGetNext = "B3E,B3M,B3G,B4E,B4M,B4G,B5E,B5M,B5G,B6E,B6M,B6G,B7E,B7M,B7G"
            let blackBoxNumber = ",\(dateLast)"
//            let valueNex = "\r"
            let valueNext = "\r\n"
            let valueReload = "PR,PW:1:\(mainPassword)"
            let FullReload = "SH,PW:1:"
            let NothingReload = "SL,PW:1:"
            _ = "\(mainPassword)\r"
            let sdVal = "SD,HK:1:1024\r"
            let sdValTwo = "SD,HK:1:\(full)"
            let sdValThree = "SD,LK:1:\(nothing)"
            let sdValTwo1 = "SD,HK:1:\(full),"
            let sdValThree1 = "SD,LK:1:\(nothing),"
            let sdParam = "SW,WM:1:\(wmPar),"
            let sdParamYet = "PW:1:\(mainPassword)"
            let passZero = "SP,PN:1:0\r"
            let passDelete = "SP,PN:1:0,"
            let passInstall = "SP,PN:1:\(mainPassword)\r"
            let enterPass = "SP,PN:1:\(mainPassword),"
            let r = "\r"
            let setZero = "SA,PW:1:\(mainPassword)\r"
            let setParamSTH = "SD,HK:1:\(valH),"
            let setParamSTL = "SD,LK:1:\(valL),"
            
            print("sdParam: \(sdParam)")
            print("sdValTwo: \(sdValTwo)")
            print("passInstall: \(passInstall)")
            
            let dataAll = Data(valueAll.utf8)
            let dataChangePassword = Data(changePassword.utf8)
            let dataChangePasswordService = Data(changePasswordService.utf8)

            let dataAll1 = Data(valueAll1.utf8)
            let dataGetIMEI = Data(getIMEI.utf8)
            let dataAllNext = Data(valueNext.utf8)
            
            let dataOnline = Data(valueOnline.utf8)
            
            let dataBlackBox = Data(blackBox.utf8)
            let dataBlackBoxNumber = Data(blackBoxNumber.utf8)
            let dataBlackBoxBreak = Data(blackBoxBreak.utf8)
            _ = Data(valueReload.utf8)
            _ = Data(FullReload.utf8)
            _ = Data(NothingReload.utf8)
            let dataSdVal = withUnsafeBytes(of: sdVal) { Data($0) }
            let dataSdValTwo = Data(sdValTwo.utf8)
            let dataSdValThree = Data(sdValThree.utf8)
            _ = Data(sdValTwo1.utf8)
            _ = Data(sdValThree1.utf8)
            let dataSdParam = Data(sdParam.utf8)
            let dataSdParamYet = Data(sdParamYet.utf8)
            _ = Data(passZero.utf8)
            let dataPassDelete = Data(passDelete.utf8)
            let dataPassInstall = Data(passInstall.utf8)
            let dataPassEnter = Data(enterPass.utf8)
            let dataR = Data(r.utf8)
            let dataConfigGet = Data(configGet.utf8)
            let dataConfigGetNext = Data(configGetNext.utf8)
            let dataConfigSet = Data(configSet.utf8)
            let dataConfigSetNext = Data(configSetNext.utf8)


            let setZeroReload = Data(setZero.utf8)
            let dataSetParamSTL = Data(setParamSTL.utf8)
            let dataSetParamSTH = Data(setParamSTH.utf8)
    
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.notify) {
                    print("Свойство \(characteristic.uuid): .notify")
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
            
            if reload == 0 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        
                        peripheral.writeValue(dataAll, for: characteristic, type: .withResponse)
                    }
                }
                reload = -1
            }
            //        if zero == 0 {
            //            for characteristic in service.characteristics! {
            //                if characteristic.properties.contains(.write) {
            //                    print("Свойство \(characteristic.uuid): .write")
            //                    peripheral.writeValue(dataPassZero, for: characteristic, type: .withResponse)
            //                    zero = 1
            //                    zeroTwo = 0
            //                }
            //            }
            //        }
            if reload == 1{
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        peripheral.writeValue(dataAll1, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataAllNext, for: characteristic, type: .withResponse)
                    }
                }
            }
            if reload == 2{
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataOnline, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataAllNext, for: characteristic, type: .withResponse)
                        print("Online")

                    }
                }
            }
            if reload == 3 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataBlackBox, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataBlackBoxNumber, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataAllNext, for: characteristic, type: .withResponse)
                    }
                }
                reload = -1
            }
            if reload == 4{
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataSdVal, for: characteristic, type: .withResponse)
                        reload = 0
                    }
                }
            }
            if reload == 5{
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataSdValTwo, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        peripheral.writeValue(dataSdValThree, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        
                        reload = -1
                    }
                }
            }
            if reload == 6 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataBlackBoxBreak, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataAllNext, for: characteristic, type: .withResponse)
                    }
                }
                reload = -1
            }
            if reload == 10 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataConfigGet, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataConfigGetNext, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataAllNext, for: characteristic, type: .withResponse)
                    }
                }
            }
            if reload == 11 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataConfigSet, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataConfigSetNext, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataAllNext, for: characteristic, type: .withResponse)
                    }
                }
            }
            if reload == 60{
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataSdParam, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        print("\(sdParam)")
                        reload = 0
                        print("dataSdParam: \(dataSdParam)")
                        print("dataSdParamYet: \(dataSdParamYet)")
                    }
                }
            }
            if reload == 7{
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataPassDelete, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        
                        reload = 0
                    }
                }
            }
            if reload == 8{
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataPassInstall, for: characteristic, type: .withResponse)
                        reload = 0
                    }
                }
            }
            if reload == 9{
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataPassEnter, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        
                        reload = 0
                    }
                }
            }
            if reload == 20 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(setZeroReload, for: characteristic, type: .withResponse)
                        reload = 0
                    }
                }
            }
            if reload == 21 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        //                    peripheral.writeValue(dataSetMode, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        reload = 0
                    }
                }
            }
            if reload == 22 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataSetParamSTL, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        peripheral.writeValue(dataSetParamSTH, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        reload = 0
                    }
                }
            }
            if reload == 23 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataSetParamSTL, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        //                    peripheral.writeValue(dataSetParamZaderV, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        //                    peripheral.writeValue(dataSetParamZaderVi, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        reload = 0
                    }
                }
            }
            if reload == 24 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataSetParamSTL, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        
                        peripheral.writeValue(dataSetParamSTH, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        
                        //                    peripheral.writeValue(dataSetParamZaderV, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        
                        //                    peripheral.writeValue(dataSetParamZaderVi, for: characteristic, type: .withoutResponse)
                        peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
                        peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                        reload = 0
                    }
                }
            }
            if reload == 25 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        
                        peripheral.writeValue(dataChangePassword, for: characteristic, type: .withResponse)
                        mainPassword = newPassword
                    }
                }
                reload = -1
            }
            if reload == 26 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        peripheral.writeValue(dataChangePasswordService, for: characteristic, type: .withResponse)
                        mainPassword = newPassword
                    }
                }
                reload = -1
            }
            if reload == 27 {
                for characteristic in service.characteristics! {
                    if characteristic.properties.contains(.write) {
                        print("Свойство \(characteristic.uuid): .write")
                        
                        peripheral.writeValue(dataGetIMEI, for: characteristic, type: .withResponse)
                    }
                }
                reload = -1
            }
        }
///
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
    }
    
    let string: String = ""
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        DispatchQueue.main.async { [self] in
        peripheral.readRSSI()
//        print("READ: \(characteristic)")
        let rxData = characteristic.value
        if let rxData = rxData {
            let numberOfBytes = rxData.count
            var rxByteArray = [UInt8](repeating: 0, count: numberOfBytes)
            (rxData as NSData).getBytes(&rxByteArray, length: numberOfBytes)
            let string = String(data: Data(rxByteArray), encoding: .utf8)
            stringAll = stringAll + string!
            print(string!)
            let result = stringAll.components(separatedBy: [":",";",",","\r","\n"])
            if result.contains("Begin Transmit") == true {
                if result.contains("End Transmit") == true {
                    dataBoxAll = "\(result)"
                    stringAll.removeAll()
                    stringAllCountBlackBox = stringAll.components(separatedBy: "\r\n").count
                    print("stringAllCountBlackBox: \(stringAllCountBlackBox)")
                    print(result)
                }
            } else {
                countBMVD = 0
                if result.count >= 0 {
                    print(result)
                    if result.contains("Access_Denied") {
                        connectedMeteoVC.setAlert()
                        connectedMeteoVC.animateIn()
                        Access_Allowed = 0
                    }
                    if result.contains("Access_Allowed") {
                        Access_Allowed = 1
                    }
                    if result.contains("QTIM") {
                        let indexOfPerson = result.firstIndex{$0 == "QTIM"}
                        if result.count > indexOfPerson! + 2 {
                            guard let a = Double(result[indexOfPerson! + 2]) else {return}
                            let date = Date(timeIntervalSince1970: a)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium
                            dateFormatter.dateStyle = DateFormatter.Style.medium
                            dateFormatter.timeZone = .current
                            let localDate = dateFormatter.string(from: date)
                            QTIM = "\(localDate)"
                            //                        print("QTIM: \(QTIM)")
                        }
                    }
                    if result.contains("QTIMQTIM") {
                        let indexOfPerson = result.firstIndex{$0 == "QTIMQTIM"}
                        if result.count > indexOfPerson! + 2 {
                            QTIM = "\(result[indexOfPerson! + 2])"
                            //                        print("QTIMQTIM: \(QTIM)")
                        }
                    }
                    if result.contains("QGSM") {
                        let indexOfPerson = result.firstIndex{$0 == "QGSM"}
                        if result.count > indexOfPerson! + 2 {
                            QGSM = "\(result[indexOfPerson! + 2])"
                            //                        print("QGSM: \(QGSM)")
                        }
                    }
                    if result.contains("TRAF") {
                        let indexOfPerson = result.firstIndex{$0 == "TRAF"}
                        if result.count > indexOfPerson! + 2 {
                            TRAF = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QGPS") {
                        let indexOfPerson = result.firstIndex{$0 == "QGPS"}
                        if result.count > indexOfPerson! + 2 {
                            QGPS = "\(result[indexOfPerson! + 2])"
                            //                        print("QGPS: \(QGPS)")
                        }
                    }
                    if result.contains("QAZI") {
                        let indexOfPerson = result.firstIndex{$0 == "QAZI"}
                        if result.count > indexOfPerson! + 2 {
                            QAZI = "\(result[indexOfPerson! + 2])"
                            //                        print("QAZI: \(QAZI)")
                        }
                    }
                    if result.contains("QPRO") {
                        let indexOfPerson = result.firstIndex{$0 == "QPRO"}
                        if result.count > indexOfPerson! + 2 {
                            QPRO = "\(result[indexOfPerson! + 2])"
                            //                        print("QPRO: \(QPRO)")
                        }
                    }
                    if result.contains("QPOP") {
                        let indexOfPerson = result.firstIndex{$0 == "QPOP"}
                        if result.count > indexOfPerson! + 2 {
                            QPOP = "\(result[indexOfPerson! + 2])"
                            //                        print("QPOP: \(QPOP)")
                        }
                    }
                    if result.contains("QBKN") {
                        let indexOfPerson = result.firstIndex{$0 == "QBKN"}
                        if result.count > indexOfPerson! + 2 {
                            QBKN = "\(result[indexOfPerson! + 2])"
                            //                        print("QBKN: \(QBKN)")
                        }
                    }
                    if result.contains("QPAK") {
                        let indexOfPerson = result.firstIndex{$0 == "QPAK"}
                        if result.count > indexOfPerson! + 2 {
                            QPAK = "\(result[indexOfPerson! + 2])"
                            //                        print("QPAK: \(QPAK)")
                        }
                    }
                    if result.contains("QBMT") {
                        let indexOfPerson = result.firstIndex{$0 == "QBMT"}
                        if result.count > indexOfPerson! + 2 {
                            QBMT = "\(result[indexOfPerson! + 2])"
                            //                        print("QBMT: \(QBMT)")
                        }
                    }
                    if result.contains("QEVS") {
                        let indexOfPerson = result.firstIndex{$0 == "QEVS"}
                        if result.count > indexOfPerson! + 2 {
                            QEVS = "\(result[indexOfPerson! + 2])"
                            //                        print("QEVS: \(QEVS)")
                        }
                    }
                    arrayState[0] = QTIM
                    arrayState[1] = QGSM
                    arrayState[2] = QGPS
                    arrayState[3] = QAZI
                    arrayState[4] = QPRO
                    arrayState[5] = QPOP
                    arrayState[6] = QBKN
                    arrayState[7] = QPAK
                    arrayState[8] = QBMT
                    arrayState[9] = QTIM
                    
                    if result.contains("UpoUpow") {
                        let indexOfPerson = result.firstIndex{$0 == "UpoUpow"}
                        if result.count > indexOfPerson! + 2 {
                            Upow = "\(result[indexOfPerson! + 2])"
                            //                        print("Upow: \(Upow)")
                        }
                    }
                    if result.contains("Upow") {
                        let indexOfPerson = result.firstIndex{$0 == "Upow"}
                        if result.count > indexOfPerson! + 2 {
                            Upow = "\(result[indexOfPerson! + 2])"
                            //                        print("Upow: \(Upow)")
                        }
                    }
                    if result.contains("t") {
                        let indexOfPerson = result.firstIndex{$0 == "t"}
                        if result.count > indexOfPerson! + 2 {
                            t = "\(result[indexOfPerson! + 2])"
                            //                        print("t: \(t)")
                        }
                    }
                    if result.contains("WD") {
                        let indexOfPerson = result.firstIndex{$0 == "WD"}
                        if result.count > indexOfPerson! + 2 {
                            WD = "\(result[indexOfPerson! + 2])"
                            //                        print("WD: \(WD)")
                        }
                    }
                    if result.contains("WV") {
                        let indexOfPerson = result.firstIndex{$0 == "WV"}
                        if result.count > indexOfPerson! + 2 {
                            WV = "\(result[indexOfPerson! + 2])"
                            //                        print("WV: \(WV)")
                        }
                    }
                    if result.contains("WM") {
                        let indexOfPerson = result.firstIndex{$0 == "WM"}
                        if result.count > indexOfPerson! + 2 {
                            WM = "\(result[indexOfPerson! + 2])"
                            //                        print("WM: \(WM)")
                        }
                    }
                    if result.contains("PR") {
                        let indexOfPerson = result.firstIndex{$0 == "PR"}
                        if result.count > indexOfPerson! + 2 {
                            PR = "\(result[indexOfPerson! + 2])"
                            //                        print("PR: \(PR)")
                        }
                    }
                    if result.contains("HM") {
                        let indexOfPerson = result.firstIndex{$0 == "HM"}
                        if result.count > indexOfPerson! + 2 {
                            HM = "\(result[indexOfPerson! + 2])"
                            //                        print("HM: \(HM)")
                        }
                    }
                    if result.contains("RN") {
                        let indexOfPerson = result.firstIndex{$0 == "RN"}
                        if result.count > indexOfPerson! + 2 {
                            RN = "\(result[indexOfPerson! + 2]) мм."
                            //                        print("RN: \(RN)")
                        }
                    }
                    if result.contains("UV") {
                        let indexOfPerson = result.firstIndex{$0 == "UV"}
                        if result.count > indexOfPerson! + 2 {
                            UV = "\(result[indexOfPerson! + 2]) Вт./м2"
                            //                        print("UV: \(UV)")
                        }
                    }
                    if result.contains("UVI") {
                        let indexOfPerson = result.firstIndex{$0 == "UVI"}
                        if result.count > indexOfPerson! + 2 {
                            UVI = "\(result[indexOfPerson! + 2]) Дж."
                            //                        print("UVI: \(UVI)")
                        }
                    }
                    if result.contains("L") {
                        let indexOfPerson = result.firstIndex{$0 == "L"}
                        if result.count > indexOfPerson! + 2 {
                            L = "\(result[indexOfPerson! + 2]) lux"
                            //                        print("L: \(L)")
                        }
                    }
                    if result.contains("LI") {
                        let indexOfPerson = result.firstIndex{$0 == "LI"}
                        if result.count > indexOfPerson! + 2 {
                            LI = "\(result[indexOfPerson! + 2]) Дж."
                            //                        print("LI: \(LI)")
                        }
                    }
                    if result.contains("KS") {
                        let indexOfPerson = result.firstIndex{$0 == "KS"}
                        if result.count > indexOfPerson! + 2 {
                            KS = "\(result[indexOfPerson! + 2])"
                            //                        print("KS: \(KS)")
                        }
                    }
                    if result.contains("RSSI") {
                        let indexOfPerson = result.firstIndex{$0 == "RSSI"}
                        if result.count > indexOfPerson! + 2 {
                            RSSI = "\(result[indexOfPerson! + 2])"
                            //                        print("RSSI: \(RSSI)")
                        }
                    }
                    for i in 0...7 {
                        if result.contains("Ex\(i)U") {
                            let indexOfPerson = result.firstIndex{$0 == "Ex\(i)U"}
                            if result.count > indexOfPerson! + 2 {
                                arrayBmvdU[i] = "\(result[indexOfPerson! + 2])"
                                countBMVD = i + 1
                            }
                        }
                        if result.contains("Ex\(i)R") {
                            let indexOfPerson = result.firstIndex{$0 == "Ex\(i)R"}
                            if result.count > indexOfPerson! + 2 {
                                arrayBmvdR[i] = "\(result[indexOfPerson! + 2])"
                            }
                        }
                    }
                    //Массив с параметрами ОНЛАЙН ДАННЫХ
                    
                    arrayMeteo[0] = Upow
                    arrayMeteo[1] = t
                    arrayMeteo[2] = WD
                    arrayMeteo[3] = WV
                    arrayMeteo[4] = WM
                    arrayMeteo[5] = PR
                    arrayMeteo[6] = HM
                    arrayMeteo[7] = RN
                    arrayMeteo[8] = UV
                    arrayMeteo[9] = UVI
                    arrayMeteo[10] = L
                    arrayMeteo[11] = LI
                    arrayMeteo[12] = RSSI
                    arrayMeteo[13] = KS
                    //Массив с параметрами СОСТОЯНИЕ ПОДКЛЮЧЕНИЯ
                    
                    arrayStateConnect[0] = QTIM
                    arrayStateConnect[1] = QGSM
                    arrayStateConnect[2] = TRAF
                    arrayStateConnect[3] = QGPS
                    
                    if result.contains("KAPI") {
                        let indexOfPerson = result.firstIndex{$0 == "KAPI"}
                        if result.count > indexOfPerson! + 2 {
                            KAPI = "\(result[indexOfPerson! + 2])"
                            //                        print("KAPI: \(KAPI)")
                        }
                    }
                    if result.contains("KUSR") {
                        let indexOfPerson = result.firstIndex{$0 == "KUSR"}
                        if result.count > indexOfPerson! + 2 {
                            KUSR = "\(result[indexOfPerson! + 2])"
                            //                        print("KUSR: \(KUSR)")
                        }
                    }
                    if result.contains("KPWD") {
                        let indexOfPerson = result.firstIndex{$0 == "KPWD"}
                        if result.count > indexOfPerson! + 2 {
                            KPWD = "\(result[indexOfPerson! + 2])"
                            //                        print("KPWD: \(KPWD)")
                        }
                    }
                    if result.contains("KPIN") {
                        let indexOfPerson = result.firstIndex{$0 == "KPIN"}
                        if result.count > indexOfPerson! + 2 {
                            KPIN = "\(result[indexOfPerson! + 2])"
                            //                        print("KPIN: \(KPIN)")
                        }
                    }
                    if result.contains("KSRV") {
                        let indexOfPerson = result.firstIndex{$0 == "KSRV"}
                        if result.count > indexOfPerson! + 2 {
                            KSRV = "\(result[indexOfPerson! + 2])"
                            //                        print("KSRV: \(KSRV)")
                        }
                    }
                    if result.contains("KPOR") {
                        let indexOfPerson = result.firstIndex{$0 == "KPOR"}
                        if result.count > indexOfPerson! + 2 {
                            KPOR = "\(result[indexOfPerson! + 2])"
                            //                        print("KPOR: \(KPOR)")
                        }
                    }
                    if result.contains("KSPW") {
                        let indexOfPerson = result.firstIndex{$0 == "KSPW"}
                        if result.count > indexOfPerson! + 2 {
                            KSPW = "\(result[indexOfPerson! + 2])"
                            //                        print("KSPW: \(KSPW)")
                        }
                    }
                    if result.contains("KPAK") {
                        let indexOfPerson = result.firstIndex{$0 == "KPAK"}
                        if result.count > indexOfPerson! + 2 {
                            KPAK = "\(result[indexOfPerson! + 2])"
                            //                        print("KPAK: \(KPAK)")
                        }
                    }
                    if result.contains("KPBM") {
                        let indexOfPerson = result.firstIndex{$0 == "KPBM"}
                        if result.count > indexOfPerson! + 2 {
                            KPBM = "\(result[indexOfPerson! + 2])"
                            //                        print("KPBM: \(KPBM)")
                        }
                    }
                    if result.contains("KCNL") {
                        let indexOfPerson = result.firstIndex{$0 == "KCNL"}
                        if result.count > indexOfPerson! + 2 {
                            KCNL = Channels(int: Int(result[indexOfPerson! + 2])!).channelsNumber()
                            //                        print("KCNL: \(KCNL)")
                        }
                    }
                    if result.contains("KBCH") {
                        let indexOfPerson = result.firstIndex{$0 == "KBCH"}
                        if result.count > indexOfPerson! + 2 {
                            KBCH = "\(result[indexOfPerson! + 2])"
                            //                        print("KBCH: \(KBCH)")
                        }
                    }
                    
                    if result.contains("APO") {
                        //                    passNotif = 0
                        //                    passwordSuccess = true
                        print("APO 0")
                    }
                    if result.contains("ADO") {
                        //                    passNotif = 0
                        //                    passwordSuccess = true
                        errorWRN = false
                        print("ADO 0")
                    }
                    if result.contains("WRN") {
                        //                    passNotif = 1
                        //                    passwordSuccess = false
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
                }
            }
        }
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
    
    var tableViewData = [cellDataDU]()
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
        return backView
    }()
    
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: -screenH / 12),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 1),
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
        tableViewData.append(cellDataDU(opened: false, title: "123", sectionData: ["123"]))
        tableViewData.insert(cellDataDU(opened: false, title: "1234", sectionData: ["1234"]), at: 0)
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
        
//        rightCount = 0
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
        
    }
    
    func popVC() {
        delegate?.buttonT()
        self.navigationController?.popViewController(animated: true)
    }
    fileprivate func startActivityIndicator() {
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.center = viewAlpha.center
        view.addSubview(viewAlpha)
        self.cancelLabel.isHidden = false
        cancelLabel.superview?.bringSubviewToFront(cancelLabel)
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.tableView.alpha = 0.0
        }) { [self] (_) in
            self.view.isUserInteractionEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if a != nil {
//            print("discont: \(a)")
            manager?.cancelPeripheralConnection(a)
        }
        startActivityIndicator()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.activityIndicator.stopAnimating()
//                self.viewAlpha.removeFromSuperview()
//                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                self.view.isUserInteractionEnabled = true
//            }
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        viewAlpha.removeFromSuperview()
        self.cancelLabel.isHidden = true
        tableView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.tableView.alpha = 1.0
        }) { [self] (_) in
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.view.isUserInteractionEnabled = true
        }
    }
    
    var tr = 0
    var container2 = UIView(frame: CGRect(x: 20, y: 50, width: Int(screenW - 40), height: 70))

    override func viewDidAppear(_ animated: Bool) {
        searchBar.text = ""
        timer.invalidate()
        self.searchBar.endEditing(true)
        self.view.isUserInteractionEnabled = true
        peripherals.removeAll()
        RSSIMainArray.removeAll()
        rrsiPink = 0
        manager?.stopScan()
        tableViewData.removeAll()
        tableViewData.append(cellDataDU(opened: false, title: "123", sectionData: ["123"]))
        tableViewData.insert(cellDataDU(opened: false, title: "1234", sectionData: ["1234"]), at: 0)
        RSSIMainArray.append("2")
        RSSIMainArray.insert("1", at: 0)
        

//        tableViewData.append(cellDataDU(opened: false, title: "1234", sectionData: ["1234"]))
        searchList.removeAll()
        searching = false
        searchBar.text = ""
        peripheralName.removeAll()
        if hidednCell == false {
            tableView.reloadData()
        }
        scanBLEDevices()
//        rightCount = 0

    }
    
    func scanBLEDevices() {
        peripherals.removeAll()
        manager?.scanForPeripherals(withServices: nil)
//        self.view.isUserInteractionEnabled = false
        var time = 0.0
        if QRCODE != "" {
            time = 12.0
        }
        //stop scanning after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 + time) {

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
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "FON")!)
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        img.alpha = 0.3
        img.frame = CGRect(x: 0, y: screenH - 260, width: 201, height: 207)
        return img
    }()
    
    fileprivate lazy var activityIndicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .zero, type: .ballGridPulse, color: UIColor.purple)
        view.frame.size = CGSize(width: 50, height: 50)
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)

        return view
    }()
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
        
//        view.addSubview(themeBackView3)
//        MainLabel.text = "List of available devices"
//        view.addSubview(MainLabel)
//        view.addSubview(backView)


        target(forAction: #selector(backTransition), withSender: UIControl.Event.touchUpInside)
        bgImage.tintColor = .black
        view.addSubview(bgImage)
        activityIndicator.startAnimating()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            if self.QRCODE == "" {
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                self.view.backgroundColor = UIColor(rgb: 0x1F2222).withAlphaComponent(1)
//            }
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
extension DevicesDUController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            manager?.scanForPeripherals(withServices: nil, options: nil)
            searching = false
            searchBar.text = ""
        }
        print(searchText)
        searchList = peripheralName.filter({$0.lowercased().contains(searchText)})
        print("searchList: \(searchList)")
//        print("peripheralName: \(peripheralName)")
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

extension DevicesDUController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !searching {
            if indexPath.section == 0 || indexPath.section == rrsiPink+1 {
                return 60
            } else {
                if indexPath.row == 0 {
                    return 73
                } else {
                    return 65
                }
            }
        } else {
            return 73
        }
    }
}


extension DevicesDUController: UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! DevicesListCellMain
//        cell.btnConnet.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
//        hidednCell = false
        if indexPath.row == 0 {
            if !searching {
                if indexPath.section == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellHeder", for: indexPath) as! DevicesListCellHeder
                    cell.titleLabel.text = "Устройства поблизости"
                    cell.titleLabel.font = UIFont(name: "FuturaPT-Medium", size: screenW / 20)
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                    
                } else if indexPath.section == rrsiPink+1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellHeder", for: indexPath) as! DevicesListCellHeder
                    cell.titleLabel.text = "Устройства с низким уровнем сигнала"
                    cell.titleLabel.font = UIFont(name: "FuturaPT-Medium", size: screenW / 20)

                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                } else {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellMain", for: indexPath) as! DevicesListCellMain
                    cell.titleLabel.text = tableViewData[indexPath.section].title
                    cell.hero.id = "ConnectToMeteo2"
                    cell.titleLabel.font = UIFont(name: "FuturaPT-Light", size: 24)
                    cell.titleRSSI.text = "\(RSSIMainArray[indexPath.section]) dBm"
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    if indexPath.section == rrsiPink {
                        cell.separetor.isHidden = true
                    } else {
                        cell.separetor.isHidden = false
                    }
                    if indexPath.section == 1  || indexPath.section == rrsiPink + 2{
                        cell.separetor2.isHidden = true
                    } else {
                        cell.separetor2.isHidden = false
                    }
                    cell.backgroundColor = .clear
                    cell.btnConnet.addTapGesture {
                        self.generator.impactOccurred()
                        temp = nil
                        nameDevice = ""
                        mainPassword = ""
//                        VV = ""
//                        level = ""
                        RSSIMain = ""
//                        vatt = ""
//                        id = ""
                        self.activityIndicator.startAnimating()
                        self.view.addSubview(self.viewAlpha)
                        self.cancelLabel.isHidden = false
                        self.cancelLabel.superview?.bringSubviewToFront(self.cancelLabel)

//                        zeroTwo = 0
//                        zero = 0
//                        countNot = 0
                        if !self.searching {
                            self.stringAll = ""
                            if indexPath.section > rrsiPink {
                                self.manager?.connect(self.peripherals[indexPath.section-2], options: nil)
                                print(self.peripherals[indexPath.section-2])
                                nameDevice = peripheralName[indexPath.section-2]
                                print("Connected to " +  nameDevice)
                            } else {
                                self.manager?.connect(self.peripherals[indexPath.section-1], options: nil)
                                nameDevice = peripheralName[indexPath.section-1]
                                print("Connected to " +  nameDevice)
                            }
                        }
//                        self.view.isUserInteractionEnabled = false
                        self.manager?.stopScan()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
//                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                            if let navController = self.navigationController {
//                                navController.pushViewController(self.connectedMeteoVC, animated: true)
//                            }
//                            self.viewAlpha.removeFromSuperview()
//                            self.cancelLabel.isHidden = true
//                        })
                    }
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellMain", for: indexPath) as! DevicesListCellMain
                cell.separetor.isHidden = false
                cell.titleLabel.text = searchList[indexPath.section]
                cell.titleLabel.font = UIFont(name: "FuturaPT-Light", size: 24)

                cell.backgroundColor = .clear
                cell.selectionStyle = .none
//                cell.titleRSSI.text = "\(RSSIMainArray[indexPath.section]) dBm"
                cell.btnConnet.addTapGesture {
                    self.generator.impactOccurred()
                    temp = nil
                    nameDevice = ""
                    mainPassword = ""
                    self.activityIndicator.startAnimating()
                    self.view.addSubview(self.viewAlpha)
                    self.cancelLabel.superview?.bringSubviewToFront(self.cancelLabel)
                    self.cancelLabel.isHidden = false
//                    zeroTwo = 0
//                    zero = 0
//                    countNot = 0
                    print(self.searchList)
                    print("indexPath.section: \(indexPath.section)")

                    print(self.searchList[indexPath.section])
                    let index = peripheralName.firstIndex(of: "\(self.searchList[indexPath.section])")
                    print("\(index!)")
                    if self.searching {
                        self.stringAll = ""
                        self.manager?.connect(self.peripherals[index!], options: nil)
                        nameDevice = peripheralName[index!]
                        print("Connected to " +  nameDevice)
                    }
//                    self.view.isUserInteractionEnabled = false
                    self.manager?.stopScan()
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                        if let navController = self.navigationController {
//                            navController.pushViewController(self.connectedMeteoVC, animated: true)
//                        }
                        self.viewAlpha.removeFromSuperview()
                        self.cancelLabel.isHidden = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

                    })
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCell", for: indexPath) as! DevicesListCell
//            cell.titleLabel.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
//            cell.macAdres.text = "MAC = F6:F6:F6:F6:F6:F6"
//            if adveLvl[indexPath.section-1] == "0" {
//                adveLvl[indexPath.section-1] = "Транспортный"
//            }
//            if adveLvl[indexPath.section-1] == "4" {
//                adveLvl[indexPath.section-1] = "Верт. вращ."
//            }
//            if adveLvl[indexPath.section-1] == "5" {
//                adveLvl[indexPath.section-1] = "Гор. вращ."
//            }
//            if adveLvl[indexPath.section-1] == "6" {
//                adveLvl[indexPath.section-1] = "Контроль угла"
//            }
//            if adveLvl[indexPath.section-1] == "9" {
//                adveLvl[indexPath.section-1] = "Ковш"
//            }
//            if adveLvl[indexPath.section-1] == "10" {
//                adveLvl[indexPath.section-1] = "Отвал"
//            }
//            cell.FW.text = "F.W. = \(adveFW[indexPath.section-1])"
            cell.FW.text = "F.W. = 1.0.2"

            cell.T.text = "Vbat = 3.5 V"
//            cell.Lvl.text = "Mode = \(adveLvl[indexPath.section-1])"
//            cell.Vbat.text = "Угол = \(adveVat[indexPath.section-1])°"
            cell.backgroundColor = .clear
            return cell
        }
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.view.endEditing(true)
//        if !searching {
//            if indexPath.section != 0 && indexPath.section != rrsiPink + 1 {
//                if indexPath.row == 0 {
//                    if tableViewData[indexPath.section].opened == true {
//                            let sections = IndexSet.init(integer: indexPath.section)
//                            tableView.reloadSections(sections, with: .none)
//                        self.tableViewData[indexPath.section].opened = false
//
//                    } else {
//
//                            self.tableViewData[indexPath.section].opened = false
//                            let sections = IndexSet.init(integer: indexPath.section)
//                            tableView.reloadSections(sections, with: .none)
//                    }
//                }
//            }
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searching {
            if tableViewData[section].opened == true {
                return tableViewData[section].sectionData.count + 1
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if !searching {
            print("tableViewData: \(tableViewData.count)")
            return tableViewData.count
        } else {
            return searchList.count
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.section == rrsiPink {
//            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 0, 0)
//            cell.layer.transform = rotationTransform
//            cell.alpha = 0.0
//            UIView.animate(withDuration: 0.5) {
//                cell.layer.transform = CATransform3DIdentity
//                cell.alpha = 1.0
//            }
//        }
//    }
}
