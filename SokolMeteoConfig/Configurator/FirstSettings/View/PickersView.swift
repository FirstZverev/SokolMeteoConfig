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
        return Channel.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = Channels(int: row).channelsNumber()
        let myTitle = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return myTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chanelTextField.text = Channels(int: row).channelsNumber()
        if row == 0 {
            channelMode(gsmMode: false, deactivate: constraints2, activate: constraints)
        } else {
            channelMode(gsmMode: true, deactivate: constraints, activate: constraints2)
        }
    }
    func channelMode(gsmMode: Bool, deactivate: [NSLayoutConstraint], activate: [NSLayoutConstraint]) {
        gsmView.isHidden = gsmMode
        NSLayoutConstraint.deactivate(deactivate)
        NSLayoutConstraint.activate(activate)
    }
}
