//
//  ListAvailTableView.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 14.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

extension ListAvailDevices: UITableViewDelegate {
    
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


extension ListAvailDevices: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                        RSSIMain = ""
                        self.activityIndicator.startAnimating()
                        self.viewAlpha.isHidden = false
                        self.cancelLabel.isHidden = false
                        self.cancelLabel.superview?.bringSubviewToFront(self.cancelLabel)
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
                        self.manager?.stopScan()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
                cell.btnConnet.addTapGesture {
                    self.generator.impactOccurred()
                    temp = nil
                    nameDevice = ""
                    mainPassword = ""
                    self.activityIndicator.startAnimating()
                    self.viewAlpha.isHidden = false
                    self.cancelLabel.superview?.bringSubviewToFront(self.cancelLabel)
                    self.cancelLabel.isHidden = false
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
                        self.viewAlpha.isHidden = true
                        self.cancelLabel.isHidden = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
                        
                    })
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCell", for: indexPath) as! DevicesListCell
            return cell
        }
    }
    
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
}
