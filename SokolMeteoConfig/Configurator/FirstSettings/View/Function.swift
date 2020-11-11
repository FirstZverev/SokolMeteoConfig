//
//  Function.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 05.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

extension ConfiguratorFirstController: UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerChanel.delegate = self
        pickerNumberChanels.delegate = self
        pickerPeriodExchange.delegate = self
        registerKeyboardNotification()
        backView.addTapGesture { [self] in self.popVC() }
        registerDelegateTextFields()

        view.backgroundColor = .white
        let customNavigationBar = createCustomNavigationBar(title: "ПЕРЕДАЧА ДАННЫХ",fontSize: screenW / 22)
        self.hero.isEnabled = true
        customNavigationBar.hero.id = "Configurator"
        
        view.sv(customNavigationBar,scrollView, backView, saveButton)
        scrollView.sv(chanelView, gsmView, serverView, dopView)
        chanelView.sv(channelLabel, chanelTextField)
        gsmView.sv(settingsLabel,accessPointLabel, userLabel, passwordLabel, pinLabel, accessPointTextField, userTextField, passwordTextField, pinTextField)
        serverView.sv(settingsServerLabel, addressLabel, portLabel, passwordDevicesLabel, periodPushLabel, addressTextField, portTextField, passwordDevicesTextField, periodTextField)
        dopView.sv(BMVDLabel,periodExchangeLabel,numberLabel,periodEchangeTextField, numberTextField)
        
        scrollViewSettings()
        view.addSubview(blurEffect)
        view.addSubview(pickerChanel)
        view.addSubview(pickerNumberChanels)
        view.addSubview(pickerPeriodExchange)
        
        pickerChanel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pickerChanel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        pickerNumberChanels.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pickerNumberChanels.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        pickerPeriodExchange.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pickerPeriodExchange.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        let constrainClose = [
            pickerChanel.topAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        let constrainOpen = [
            pickerChanel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        let constrainCloseNumber = [
            pickerNumberChanels.topAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        let constrainOpenNumber = [
            pickerNumberChanels.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        let constrainCloseExchange = [
            pickerPeriodExchange.topAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        let constrainOpenNumberExchange = [
            pickerPeriodExchange.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constrainClose)
        NSLayoutConstraint.activate(constrainCloseNumber)
        NSLayoutConstraint.activate(constrainCloseExchange)

        scrollView.addTapGesture {
            self.scrollView.endEditing(true)
        }
        chanelTextField.addTapGesture { [self] in
            print("chanelTextField")
            self.scrollView.endEditing(true)
            self.pickerChanel.isHidden = false
            self.blurEffect.isHidden = false
            self.pickerChanel.selectRow(Channels(string: KCNL).channelsString(), inComponent: 0, animated: true)
            UIView.animate(withDuration: 0.3, animations: {
                self.blurEffect.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: 0.5) {
                    NSLayoutConstraint.deactivate(constrainClose)
                    NSLayoutConstraint.activate(constrainOpen)
                    self.view.layoutIfNeeded()
                }
            }
        }
        numberTextField.addTapGesture { [self] in
            print("chanelTextField")
            self.scrollView.endEditing(true)
            self.pickerNumberChanels.isHidden = false
            self.blurEffect.isHidden = false
            self.pickerNumberChanels.selectRow(Numbers(string: KBCH).channelsString(), inComponent: 0, animated: true)
            UIView.animate(withDuration: 0.3, animations: {
                self.blurEffect.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: 0.5) {
                    NSLayoutConstraint.deactivate(constrainCloseNumber)
                    NSLayoutConstraint.activate(constrainOpenNumber)
                    self.view.layoutIfNeeded()
                }
            }
        }
        periodEchangeTextField.addTapGesture { [self] in
            print("chanelTextField")
            self.scrollView.endEditing(true)
            self.pickerPeriodExchange.isHidden = false
            self.blurEffect.isHidden = false
            self.pickerPeriodExchange.selectRow(Exchanges(string: KPBM).channelsString(), inComponent: 0, animated: true)
            UIView.animate(withDuration: 0.3, animations: {
                self.blurEffect.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: 0.5) {
                    NSLayoutConstraint.deactivate(constrainCloseExchange)
                    NSLayoutConstraint.activate(constrainOpenNumberExchange)
                    self.view.layoutIfNeeded()
                }
            }
        }
        blurEffect.addTapGesture { [self] in
            print("blurEffect")
            NSLayoutConstraint.deactivate(constrainClose)
            NSLayoutConstraint.activate(constrainOpen)
            
            UIView.animate(withDuration: 0.3, animations: {
                NSLayoutConstraint.deactivate(constrainOpen)
                NSLayoutConstraint.deactivate(constrainOpenNumber)
                NSLayoutConstraint.deactivate(constrainOpenNumberExchange)
                NSLayoutConstraint.activate(constrainClose)
                NSLayoutConstraint.activate(constrainCloseNumber)
                NSLayoutConstraint.activate(constrainCloseExchange)
                self.blurEffect.alpha = 0.0
                self.view.layoutIfNeeded()
            }) { _ in
                self.blurEffect.isHidden = true
            }
        }
        viewAlpha.isHidden = false
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(viewAlpha)
    }
    override func viewWillAppear(_ animated: Bool) {
        viewAlpha.isHidden = false
        if KCNL == "GSM" {
            channelMode(gsmMode: false, deactivate: constraints2, activate: constraints)
        } else {
            channelMode(gsmMode: true, deactivate: constraints, activate: constraints2)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        reload = 11
        delegate?.buttonTapFirstConfigurator()
//        DispatchQueue.main.async { [self] in
//            timer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (timer) in
//                self.updateInterface()
//            }
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
//        reload = -1
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateInterface() {
        chanelTextField.text = KCNL
        accessPointTextField.text = KAPI
        userTextField.text = KUSR
        passwordTextField.text = KPWD
        pinTextField.text = KPIN
        
        addressTextField.text = KSRV
        portTextField.text = KPOR
        passwordDevicesTextField.text = KSPW
        periodTextField.text = KPAK
        
        periodEchangeTextField.text = KPBM
        numberTextField.text = KBCH
        
        if Channels(string: KCNL).channelsString() == 0 {
            channelMode(gsmMode: false, deactivate: constraints2, activate: constraints)
        } else {
            channelMode(gsmMode: true, deactivate: constraints, activate: constraints2)
        }
    }
    
    fileprivate func registerDelegateTextFields() {
        accessPointTextField.delegate = self
        userTextField.delegate = self
        passwordDevicesTextField.delegate = self
        passwordTextField.delegate = self
        pinTextField.delegate = self
        addressTextField.delegate = self
        portTextField.delegate = self
        periodTextField.delegate = self
        periodEchangeTextField.delegate = self
        numberTextField.delegate = self
        chanelTextField.delegate = self
    }
    
    fileprivate func registerKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func saveUpdate() {
        viewAlpha.isHidden = false
        KCNL = "\(Channels(string: chanelTextField.text).channelsString())"
        KAPI = accessPointTextField.text ?? ""
        KUSR = userTextField.text ?? ""
        KPWD = passwordTextField.text ?? ""
        KPIN = pinTextField.text ?? ""
        
        KSRV = addressTextField.text ?? ""
        KPOR = portTextField.text ?? ""
        KSPW = passwordDevicesTextField.text ?? ""
        KPAK = periodTextField.text ?? ""
        
        KPBM = periodEchangeTextField.text ?? ""
        KBCH = numberTextField.text ?? ""
        
        reload = 7
        delegate?.buttonTapFirstConfigurator()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
                scrollView.contentInset = contentInset
                saveButton.contentEdgeInsets = contentInset
            
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            saveButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom - 80, right: 0)

        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(rgb: 0xF06BCD).cgColor
        textField.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        textField.layer.shadowOpacity = 0.0
    }
    fileprivate func scrollViewSettings() {
        constraints = [
            serverView.width(screenW - 40).left(20).topAnchor.constraint(equalTo: gsmView.bottomAnchor, constant: 30),
            serverView.bottomAnchor.constraint(equalTo: periodPushLabel.bottomAnchor, constant: 20)
            ]
        constraints2 = [
            serverView.width(screenW - 40).left(20).topAnchor.constraint(equalTo: chanelView.bottomAnchor, constant: 30),
            serverView.bottomAnchor.constraint(equalTo: periodPushLabel.bottomAnchor, constant: 20)
            ]
        NSLayoutConstraint.activate(constraints)

        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 + 5).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
        scrollView.contentSize = CGSize(width: Int(screenW), height: 800)
        
        chanelView.width(screenW - 40).left(20).topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        chanelView.bottomAnchor.constraint(equalTo: channelLabel.bottomAnchor, constant: 10).isActive = true

        channelLabel.left(10).topAnchor.constraint(equalTo: chanelView.topAnchor, constant: 10).isActive = true
        channelLabel.trailingAnchor.constraint(equalTo: chanelTextField.leadingAnchor, constant: -20).isActive = true

        chanelTextField.height(30).trailingAnchor.constraint(equalTo: chanelView.trailingAnchor, constant: -15).isActive = true
        chanelTextField.topAnchor.constraint(equalTo: channelLabel.topAnchor, constant: -5).isActive = true

        gsmView.width(screenW - 40).left(20).topAnchor.constraint(equalTo: chanelView.bottomAnchor, constant: 30).isActive = true
        gsmView.bottomAnchor.constraint(equalTo: pinLabel.bottomAnchor, constant: 20).isActive = true

        serverView.width(screenW - 40).left(20).topAnchor.constraint(equalTo: gsmView.bottomAnchor, constant: 30).isActive = true
        serverView.bottomAnchor.constraint(equalTo: periodPushLabel.bottomAnchor, constant: 20).isActive = true
        dopView.width(screenW - 40).left(20).topAnchor.constraint(equalTo: serverView.bottomAnchor, constant: 30).isActive = true
        dopView.bottomAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 20).isActive = true

        settingsLabel.left(10).topAnchor.constraint(equalTo: gsmView.topAnchor).isActive = true
        accessPointLabel.left(10).topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 20).isActive = true
        accessPointLabel.trailingAnchor.constraint(equalTo: accessPointTextField.leadingAnchor, constant: -20).isActive = true
        userLabel.left(10).topAnchor.constraint(equalTo: accessPointLabel.bottomAnchor, constant: 20).isActive = true
        userLabel.trailingAnchor.constraint(equalTo: userTextField.leadingAnchor, constant: -20).isActive = true
        passwordLabel.left(10).topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 20).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: -20).isActive = true
        pinLabel.left(10).topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 20).isActive = true
        pinLabel.trailingAnchor.constraint(equalTo: pinTextField.leadingAnchor, constant: -20).isActive = true

        accessPointTextField.height(30).trailingAnchor.constraint(equalTo: gsmView.trailingAnchor, constant: -15).isActive = true
        accessPointTextField.topAnchor.constraint(equalTo: accessPointLabel.topAnchor, constant: -5).isActive = true

        userTextField.height(30).trailingAnchor.constraint(equalTo: gsmView.trailingAnchor, constant: -15).isActive = true
        userTextField.topAnchor.constraint(equalTo: userLabel.topAnchor, constant: -5).isActive = true

        passwordTextField.height(30).trailingAnchor.constraint(equalTo: gsmView.trailingAnchor, constant: -15).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.topAnchor, constant: -5).isActive = true

        pinTextField.height(30).trailingAnchor.constraint(equalTo: gsmView.trailingAnchor, constant: -15).isActive = true
        pinTextField.topAnchor.constraint(equalTo: pinLabel.topAnchor, constant: -5).isActive = true


        settingsServerLabel.width(screenW - 40).left(10).topAnchor.constraint(equalTo: serverView.topAnchor).isActive = true
        addressLabel.left(10).topAnchor.constraint(equalTo: settingsServerLabel.bottomAnchor, constant: 20).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: addressTextField.leadingAnchor, constant: -20).isActive = true
        portLabel.left(10).topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20).isActive = true
        portLabel.trailingAnchor.constraint(equalTo: portTextField.leadingAnchor, constant: -20).isActive = true
        passwordDevicesLabel.left(10).topAnchor.constraint(equalTo: portLabel.bottomAnchor, constant: 20).isActive = true
        passwordDevicesLabel.width(screenW / 2 + 30).trailingAnchor.constraint(equalTo: passwordDevicesTextField.leadingAnchor, constant: 0).isActive = true
        periodPushLabel.left(10).topAnchor.constraint(equalTo: passwordDevicesLabel.bottomAnchor, constant: 20).isActive = true
        periodPushLabel.width(screenW / 2).trailingAnchor.constraint(equalTo: periodTextField.leadingAnchor, constant: 0).isActive = true

        addressTextField.height(30).trailingAnchor.constraint(equalTo: serverView.trailingAnchor, constant: -15).isActive = true
        addressTextField.topAnchor.constraint(equalTo: addressLabel.topAnchor, constant: -5).isActive = true

        portTextField.height(30).trailingAnchor.constraint(equalTo: serverView.trailingAnchor, constant: -15).isActive = true
        portTextField.topAnchor.constraint(equalTo: portLabel.topAnchor, constant: -5).isActive = true

        passwordDevicesTextField.height(30).trailingAnchor.constraint(equalTo: serverView.trailingAnchor, constant: -15).isActive = true
        passwordDevicesTextField.topAnchor.constraint(equalTo: passwordDevicesLabel.topAnchor, constant: -5).isActive = true

        periodTextField.height(30).trailingAnchor.constraint(equalTo: serverView.trailingAnchor, constant: -15).isActive = true
        periodTextField.topAnchor.constraint(equalTo: periodPushLabel.topAnchor, constant: -5).isActive = true
        
        BMVDLabel.left(10).right(10).topAnchor.constraint(equalTo: dopView.topAnchor).isActive = true
        periodExchangeLabel.left(10).topAnchor.constraint(equalTo: BMVDLabel.bottomAnchor, constant: 20).isActive = true
        periodExchangeLabel.trailingAnchor.constraint(equalTo: periodEchangeTextField.leadingAnchor, constant: -20).isActive = true
        numberLabel.left(10).topAnchor.constraint(equalTo: periodExchangeLabel.bottomAnchor, constant: 20).isActive = true
        numberLabel.width(screenW / 2).trailingAnchor.constraint(equalTo: numberTextField.leadingAnchor, constant: -20).isActive = true
        
        periodEchangeTextField.height(30).trailingAnchor.constraint(equalTo: dopView.trailingAnchor, constant: -15).isActive = true
        periodEchangeTextField.topAnchor.constraint(equalTo: periodExchangeLabel.topAnchor, constant: -5).isActive = true

        numberTextField.height(30).trailingAnchor.constraint(equalTo: dopView.trailingAnchor, constant: -15).isActive = true
        numberTextField.topAnchor.constraint(equalTo: numberLabel.topAnchor, constant: -5).isActive = true
        
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberTextField {
            do {
                let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let regex = try NSRegularExpression(pattern: "^([0-9]{0,1})$", options: [])
                if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
                    != nil {
                    return true
                }
            }
            catch {
                print("ERROR")
            }
        } else if textField == pinTextField {
            do {
                let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let regex = try NSRegularExpression(pattern: "^([0-9]{0,4})$", options: [])
                if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
                    != nil {
                    return true
                }
            }
            catch {
                print("ERROR")
            }
        } else if textField == addressTextField {
            do {
                let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let regex = try NSRegularExpression(pattern: "^([a-zA-Z0-9.]{0,25})$", options: [])
                if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
                    != nil {
                    return true
                }
            }
            catch {
                print("ERROR")
            }
        } else if textField == portTextField {
            do {
                let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let regex = try NSRegularExpression(pattern: "^([0-9]{0,5})$", options: [])
                if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
                    != nil {
                    return true
                }
            }
            catch {
                print("ERROR")
            }
        } else if textField == passwordDevicesTextField {
            do {
                let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let regex = try NSRegularExpression(pattern: "^([0-9]{0,5})$", options: [])
                if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
                    != nil {
                    return true
                }
            }
            catch {
                print("ERROR")
            }
        } else if textField == passwordTextField {
            do {
                let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let regex = try NSRegularExpression(pattern: "^([a-zA-Z0-9]{0,20})$", options: [])
                if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
                    != nil {
                    return true
                }
            }
            catch {
                print("ERROR")
            }
        } else if textField == userTextField {
            do {
                let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let regex = try NSRegularExpression(pattern: "^([a-zA-Z0-9]{0,20})$", options: [])
                if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
                    != nil {
                    return true
                }
            }
            catch {
                print("ERROR")
            }
        } else if textField == accessPointTextField {
            do {
                let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let regex = try NSRegularExpression(pattern: "^([a-zA-Z0-9.]{0,30})$", options: [])
                if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
                    != nil {
                    return true
                }
            }
            catch {
                print("ERROR")
            }
        } else if textField == periodTextField {
            do {
                let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let regex = try NSRegularExpression(pattern: "^([0-9]{0,2})$", options: [])
                if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
                    != nil {
                    let intvalue = Int(text)
                    return (intvalue ?? 10 >= 0 && intvalue ?? 10 <= 59)
                }
            }
            catch {
                print("ERROR")
            }
        }
        return false
    }
}
