//
//  BluetoothService.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//
import CoreBluetooth
import UIKit

extension ListAvailDevices : CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if advertisementData["kCBAdvDataLocalName"] as? String != nil {
            let nameDevicesOps = (advertisementData["kCBAdvDataLocalName"] as? String)?.components(separatedBy: ["_"])
            if nameDevicesOps?[0] == "Sokol-M" && nameDevicesOps?[1] != "UPDATE" {
                if(!peripherals.contains(peripheral)) {
                    print(RSSI)
                    if RSSI != 127{
                        let orderNum: NSNumber? = RSSI
                        let orderNumberInt  = orderNum?.intValue
                        if -71 < orderNumberInt! {
                            rrsiPink = rrsiPink + 1
                            peripherals.insert(peripheral, at: rrsiPink - 1)
                            peripheralName.insert(advertisementData["kCBAdvDataLocalName"] as! String, at: rrsiPink - 1)
                            tableViewData.insert(cellDataPeripheral(opened: false, title: "\(advertisementData["kCBAdvDataLocalName"] as! String)", sectionData: ["\(advertisementData["kCBAdvDataLocalName"] as! String)"]), at: rrsiPink)
                            RSSIMainArray.insert("\(RSSI)", at: rrsiPink)
                            stopActivityIndicator()
                            tableView.reloadData()
                        } else {
                            peripherals.append(peripheral)
                            peripheralName.append(advertisementData["kCBAdvDataLocalName"] as! String)
                            tableViewData.append(cellDataPeripheral(opened: false, title: "\(advertisementData["kCBAdvDataLocalName"] as! String)", sectionData: ["\(advertisementData["kCBAdvDataLocalName"] as! String)"]))
                            RSSIMainArray.append("\(RSSI)")
                            stopActivityIndicator()
                            tableView.reloadData()
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
                tableView.reloadData()
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        RSSIMain = "\(RSSI)"
    }
    
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
            print("Bluetooth OFF.")
//            let alert = UIAlertController(title: "Bluetooth выключен", message: "Для дальнейшей работы необходимо включить Bluetooth", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Настройки", style: .default, handler: { action in
//                                            switch action.style{
//                                            case .default:
//                                                UIApplication.shared.open(URL(string: "App-prefs:Bluetooth")!)
//                                                print("default")
//                                                self.navigationController?.popViewController(animated: true)
//                                                self.view.subviews.forEach({ $0.removeFromSuperview() })
//                                            case .cancel:
//                                                print("cancel")
//                                            case .destructive:
//                                                print("destructive")
//                                            @unknown default:
//                                                fatalError()
//                                            }}))
//            self.present(alert, animated: true, completion: nil)
            setAlertBle()
            animateIn()

        }
    }
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if let navController = self.navigationController {
            Access_Allowed = 0
            mainPassword = ""
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
}
