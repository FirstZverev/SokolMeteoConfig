//
//  SelectPush.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 27.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import SimpleCheckbox

class SelectPush: UIView {
    let generator = UIImpactFeedbackGenerator(style: .light)
    @IBOutlet weak var CustomEnter: UIButton!
    @IBOutlet weak var CustomMainLabel: UILabel!
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var CloseImage: UIButton!
    
    @IBOutlet var checkBoxOne: Checkbox!
    @IBOutlet var checkBoxTwo: Checkbox!
    weak var delegate: AlertDelegate?

    @IBOutlet weak var labelCom: UILabel!
    @IBOutlet weak var labelCsv: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customeizingButton()
        customeizingContentView()
    }
    
    func set(title: String, body: String, buttonTitle: String) {
        CustomMainLabel.text = title
        CustomEnter.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func ActionButton(_ sender: Any) {
        delegate?.buttonTapped()
    }
    @IBAction func clouseButton(sender: Any) {
        delegate?.buttonClose()
    }
    
    func customeizingButton() {
        CustomEnter.layer.cornerRadius = 10
        checkBoxOne.checkedBorderColor = UIColor(rgb: 0xBE449E)
        checkBoxOne.uncheckedBorderColor = UIColor(rgb: 0xBE449E)
        checkBoxOne.checkmarkColor = UIColor(rgb: 0xBE449E)
        checkBoxOne.borderStyle = .circle
        checkBoxOne.checkmarkStyle = .circle
        checkBoxOne.useHapticFeedback = true
        checkBoxOne.isChecked = true
        checkBoxOne.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)

        checkBoxTwo.checkedBorderColor = UIColor(rgb: 0xBE449E)
        checkBoxTwo.checkmarkColor = UIColor(rgb: 0xBE449E)
        checkBoxTwo.uncheckedBorderColor = UIColor(rgb: 0xBE449E)
        checkBoxTwo.borderStyle = .circle
        checkBoxTwo.checkmarkStyle = .circle
        checkBoxTwo.useHapticFeedback = true
        checkBoxTwo.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        
        labelCom.addTapGesture { [self] in
            generator.impactOccurred()
            checkBoxOne.isChecked = true
            checkBoxTwo.isChecked = false
        }
        labelCsv.addTapGesture { [self] in
            generator.impactOccurred()
            checkBoxTwo.isChecked = true
            checkBoxOne.isChecked = false
        }
    }
    @objc func checkboxValueChanged(sender: Checkbox!) {
        if sender == checkBoxOne {
            print("checkBoxOne")
            if sender.isChecked == false {
                sender.isChecked = true
                checkBoxTwo.isChecked = false
            } else {
                checkBoxTwo.isChecked = false
            }
        } else {
            print("checkBoxTwo")
            if sender.isChecked == false {
                sender.isChecked = true
                checkBoxOne.isChecked = false
            } else {
                checkBoxOne.isChecked = false
            }
        }
    }
    func customeizingContentView() {
        ContentView.layer.cornerRadius = 20
        ContentView.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        ContentView.layer.shadowRadius = 20.0
        ContentView.layer.shadowOpacity = 0.5
        ContentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
}
