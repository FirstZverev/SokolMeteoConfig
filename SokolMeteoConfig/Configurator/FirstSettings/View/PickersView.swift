//
//  PickersView.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 06.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

extension ConfiguratorFirstController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerChanel {
            return Channel.allCases.count
        } else if pickerView == pickerNumberChanels {
            return Number.allCases.count
        } else  if pickerView == pickerPeriodExchange {
            return Exchange.allCases.count
        } else{
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""
        if pickerView == pickerChanel {
            string = Channels(int: row).channelsNumber()
        } else if pickerView == pickerNumberChanels {
            string = Numbers(int: row).channelsNumber()
        }else if pickerView == pickerPeriodExchange {
            string = Exchanges(int: row).channelsNumber()
        }
        let myTitle = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return myTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerChanel {
            chanelTextField.text = Channels(int: row).channelsNumber()
            if row == 0 {
                channelMode(gsmMode: false, deactivate: constraints2, activate: constraints)
            } else {
                channelMode(gsmMode: true, deactivate: constraints, activate: constraints2)
            }
        } else if pickerView == pickerNumberChanels {
            numberTextField.text = Numbers(int: row).channelsNumber()
        } else if pickerView == pickerPeriodExchange {
            periodEchangeTextField.text = Exchanges(int: row).channelsNumber()
        }

    }
    func channelMode(gsmMode: Bool, deactivate: [NSLayoutConstraint], activate: [NSLayoutConstraint]) {
        gsmView.isHidden = gsmMode
        NSLayoutConstraint.deactivate(deactivate)
        NSLayoutConstraint.activate(activate)
    }
}
