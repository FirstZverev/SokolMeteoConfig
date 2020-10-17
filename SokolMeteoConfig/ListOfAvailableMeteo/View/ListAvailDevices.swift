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
    var stringAllCountBlackBox = 0
    var iter = false
    var parsedData:[String : AnyObject] = [:]
    var bluetoothPeripheralManager: CBPeripheralManager?
    var searchList = [String]()
    let generator = UIImpactFeedbackGenerator(style: .light)
    
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
    func buttonTap() {
        if reload != 6 {
            stringAll.removeAll()
        }
        peripheral(CBPeripheralForDisconnect, didDiscoverCharacteristicsFor: CBServiceForDisconnect, error: nil)
        print("Password ENTER")
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
            let configSet = "Set,KSPW:3:8002,KSRV:3:tcp.sokolmeteo.com,KPBM:1:30,KCNL:1:4,KBCH:1:0,"
            let configSetNext = "KPWD:3:beeline,KPAK:1:30,KPOR:3:8002,KAPI:3:m2m.beeline.ru"
            let configGet = "Get,B0E,B0M,B0G,B1E,B1M,B1G,B2E,B2M,B2G,"
            let configGetNext = "B3E,B3M,B3G,B4E,B4M,B4G,B5E,B5M,B5G,B6E,B6M,B6G,B7E,B7M,B7G"
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
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [blackBox,blackBoxNumber,valueNext])
                    case 4: break
                    case 5: break
                    case 6:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [blackBoxBreak,valueNext])
                    case 7: break
                    case 8: break
                    case 9: break
                    case 10:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [configGet,configGetNext,valueNext])
                    case 11:
                        self.dataValueChange(peripheralCBCharacteristic: [peripheral, characteristic], valuesString: [configSet,configSetNext,valueNext])
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
    
    let string: String = ""
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        DispatchQueue.main.async { [self] in
            peripheral.readRSSI()
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
                    print(result)
                    if result.contains("Access_Denied") {
                        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
                            arrayState[0] = "\(localDate)"
                            arrayStateConnect[0] = "\(localDate)"
                        }
                    }
                    if result.contains("QGSM") {
                        let indexOfPerson = result.firstIndex{$0 == "QGSM"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[1] = "\(result[indexOfPerson! + 2])"
                            arrayStateConnect[1] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QGPS") {
                        let indexOfPerson = result.firstIndex{$0 == "QGPS"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[2] = "\(result[indexOfPerson! + 2])"
                            arrayStateConnect[3] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QAZI") {
                        let indexOfPerson = result.firstIndex{$0 == "QAZI"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[3] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QPRO") {
                        let indexOfPerson = result.firstIndex{$0 == "QPRO"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[4] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QPOP") {
                        let indexOfPerson = result.firstIndex{$0 == "QPOP"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[5] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QBKN") {
                        let indexOfPerson = result.firstIndex{$0 == "QBKN"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[6] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QPAK") {
                        let indexOfPerson = result.firstIndex{$0 == "QPAK"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[7] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QBMT") {
                        let indexOfPerson = result.firstIndex{$0 == "QBMT"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[8] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("UBAT") {
                        let indexOfPerson = result.firstIndex{$0 == "UBAT"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[9] = "\(result[indexOfPerson! + 2])"
                            arrayStateConnect[5] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("UEXT") {
                        let indexOfPerson = result.firstIndex{$0 == "UEXT"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[10] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("KS") {
                        let indexOfPerson = result.firstIndex{$0 == "KS"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[11] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("RSSI") {
                        let indexOfPerson = result.firstIndex{$0 == "RSSI"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[12] = "\(result[indexOfPerson! + 2])"
                            arrayStateConnect[4] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("TRAF") {
                        let indexOfPerson = result.firstIndex{$0 == "TRAF"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[13] = "\(result[indexOfPerson! + 2])"
                            arrayStateConnect[2] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("QEVS") {
                        let indexOfPerson = result.firstIndex{$0 == "QEVS"}
                        if result.count > indexOfPerson! + 2 {
                            arrayState[14] = "\(result[indexOfPerson! + 2])"
                            connectedMeteoVC.tabBarVC.searchVC.tableView.reloadData()
                        }
                    }
                    
                    if result.contains("t") {
                        let indexOfPerson = result.firstIndex{$0 == "t"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[0] = "\(result[indexOfPerson! + 2]) °C"
                        }
                    }
                    if result.contains("WD") {
                        let indexOfPerson = result.firstIndex{$0 == "WD"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[1] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("WV") {
                        let indexOfPerson = result.firstIndex{$0 == "WV"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[2] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("WM") {
                        let indexOfPerson = result.firstIndex{$0 == "WM"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[3] = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("PR") {
                        let indexOfPerson = result.firstIndex{$0 == "PR"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[4] = "\(result[indexOfPerson! + 2]) гПа"
                        }
                    }
                    if result.contains("HM") {
                        let indexOfPerson = result.firstIndex{$0 == "HM"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[5] = "\(result[indexOfPerson! + 2]) %"
                        }
                    }
                    if result.contains("RN") {
                        let indexOfPerson = result.firstIndex{$0 == "RN"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[6] = "\(result[indexOfPerson! + 2]) мм"
                        }
                    }
                    if result.contains("UV") {
                        let indexOfPerson = result.firstIndex{$0 == "UV"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[7] = "\(result[indexOfPerson! + 2]) Вт/м2"
                        }
                    }
                    if result.contains("UVI") {
                        let indexOfPerson = result.firstIndex{$0 == "UVI"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[8] = "\(result[indexOfPerson! + 2]) Дж"
                        }
                    }
                    if result.contains("L") {
                        let indexOfPerson = result.firstIndex{$0 == "L"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[9] = "\(result[indexOfPerson! + 2]) lux"
                        }
                    }
                    if result.contains("LI") {
                        let indexOfPerson = result.firstIndex{$0 == "LI"}
                        if result.count > indexOfPerson! + 2 {
                            arrayMeteo[10] = "\(result[indexOfPerson! + 2]) Дж"
                            connectedMeteoVC.tabBarVC.mainVC.tableView.reloadData()
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
        return backView
    }()
    
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 + searchBar.bounds.height + 5),
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
        
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    func startActivityIndicator() {
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
        startActivityIndicator()
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
    override func viewDidAppear(_ animated: Bool) {
        if CBPeripheralForDisconnect != nil {
            manager?.cancelPeripheralConnection(CBPeripheralForDisconnect)
        }
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
