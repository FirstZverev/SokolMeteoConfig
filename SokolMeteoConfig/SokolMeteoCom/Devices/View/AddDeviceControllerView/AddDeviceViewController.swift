//
//  AddDeviceViewController.swift
//  SOKOL
//
//  Created by Володя Зверев on 18.01.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import UIKit
import RealmSwift
import SimpleCheckbox

class AddDeviceViewController : UIViewController, UITextFieldDelegate {
    
    let networkManager = NetworkManager()
    var editBool = false
    var tag = 0
    var tagSelectProfile = 0
    let viewModel: ServiceModel = ServiceModel()

    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        backView.hero.id = "backView"
        return backView
    }()
    var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0xBE449E)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionSave), for: .touchUpInside)
        return button
    }()
    lazy var Mainlabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nameDeviceLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя устройства*"
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "*обязательно к заполнению"
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameDeviceTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "Sokol_M-123")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    lazy var imeiDeviceLabel: UILabel = {
        let label = UILabel()
        label.text = "IMEI-код*"
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imeiDeviceTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "12345678910")
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    lazy var passwordDeviceLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль*"
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var checkBox: Checkbox = {
        let checkBox = Checkbox()
        checkBox.checkedBorderColor = UIColor(rgb: 0xBE449E)
        checkBox.uncheckedBorderColor = UIColor(rgb: 0x998F99)
        checkBox.checkmarkColor = .white
        checkBox.borderStyle = .square
        checkBox.borderLineWidth = 1
        checkBox.checkboxFillColor = UIColor(rgb: 0xBE449E)
        checkBox.checkmarkStyle = .tick
        checkBox.useHapticFeedback = true
        checkBox.isChecked = true
        checkBox.borderCornerRadius = 5
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        return checkBox
    }()
    lazy var saveLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Light", size: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Прогноз"
        return label
    }()
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        view.layer.shadowRadius = 3.0
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var passwordDeviceTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "*******")
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @objc func checkboxValueChanged(sender: Checkbox!) {
        checkBoxSender()
    }
    fileprivate func checkBoxSender() {
        if checkBox.isChecked == false {
            checkBox.checkmarkColor = UIColor(rgb: 0xBE449E)
            checkBox.checkboxFillColor = .clear
        } else {
            checkBox.checkmarkColor = .white
            checkBox.checkboxFillColor = UIColor(rgb: 0xBE449E)
        }
    }
    
    @objc func actionSave() {
        var userData: [String : Any] = [:]
        guard let permissions = devicesList[tag].permissions else {return}
        if editBool {
            userData = [
                "id": "\(devicesList[tag].id ?? "")",
                "name": "\(nameDeviceTextField.text ?? "")",
                "imei": "\(imeiDeviceTextField.text ?? "")",
                "password": "\(passwordDeviceTextField.text ?? "")",
                "forecastActive": checkBox.isChecked,
                "permissions": [
                    [
                        "userId": permissions.first?.userID,
                        "userEmail": permissions.first?.userEmail,
                        "userPermissionId": permissions.first?.userPermissionID
                    ]
                ]
            ]
        } else {
            userData = ["name": "\(nameDeviceTextField.text ?? "")", "imei": "\(imeiDeviceTextField.text ?? "")", "password": "\(passwordDeviceTextField.text ?? "")", "forecastActive": checkBox.isChecked]
        }
        print("userData: \(userData)")
        viewAlphaAlways.isHidden = false
        networkManager.networkingPostRequestAddDevice(userDataJSON: userData) { (string, error) in
            DispatchQueue.main.async {
                viewAlphaAlways.isHidden = true
                self.popVC()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if editBool {
            Mainlabel.text = "Изменить устройство"
            nameDeviceTextField.text = devicesList[tag].name
            imeiDeviceTextField.text = devicesList[tag].imei
            passwordDeviceTextField.text = devicesList[tag].password
            saveButton.setTitle("Сохранить данные", for: .normal)
        } else {
            Mainlabel.text = "Добавить устройство"
            nameDeviceTextField.text = ""
            imeiDeviceTextField.text = ""
            passwordDeviceTextField.text = ""
            saveButton.setTitle("Добавить устройство", for: .normal)
        }
        guard let bool = devicesList[tag].forecastActive else {return}
        checkBox.isChecked = bool
        checkBoxSender()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        var realmDevice = realm.objects(DeviceNameModel.self)
//        let a = map(realmDevice) {$0.name}
        let customNavigationBar = createCustomNavigationBar(title: "SOKOLMETEO",fontSize: screenW / 22)
        self.hero.isEnabled = true

        view.sv(customNavigationBar, backView)
        customNavigationBar.hero.id = "SOKOLMETEO"
        backView.addTapGesture { [self] in self.popVC() }
        nameDeviceTextField.delegate = self
        imeiDeviceTextField.delegate = self
        passwordDeviceTextField.delegate = self
        
        view.addSubview(backgroundView)
        view.addSubview(Mainlabel)
        backgroundView.addSubview(nameDeviceLabel)
        backgroundView.addSubview(imeiDeviceLabel)
        backgroundView.addSubview(passwordDeviceLabel)
        backgroundView.addSubview(infoLabel)

        backgroundView.addSubview(nameDeviceTextField)
        backgroundView.addSubview(imeiDeviceTextField)
        backgroundView.addSubview(passwordDeviceTextField)
        backgroundView.addSubview(checkBox)
        backgroundView.addSubview(saveLabel)
        view.addSubview(saveButton)
        
        Mainlabel.topAnchor.constraint(equalTo: view.topAnchor, constant: (screenH / 12) + 20).isActive = true
        Mainlabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        Mainlabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true

        
        backgroundView.topAnchor.constraint(equalTo: Mainlabel.bottomAnchor, constant: 15).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        nameDeviceLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 25).isActive = true
        nameDeviceLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10).isActive = true
        
        nameDeviceTextField.centerYAnchor.constraint(equalTo: nameDeviceLabel.centerYAnchor).isActive = true
        nameDeviceTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15).isActive = true
        nameDeviceTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameDeviceTextField.widthAnchor.constraint(equalToConstant: screenW / 2 - 15).isActive = true


        imeiDeviceLabel.topAnchor.constraint(equalTo: nameDeviceLabel.bottomAnchor, constant: 30).isActive = true
        imeiDeviceLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10).isActive = true

        imeiDeviceTextField.centerYAnchor.constraint(equalTo: imeiDeviceLabel.centerYAnchor).isActive = true
        imeiDeviceTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15).isActive = true
        imeiDeviceTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imeiDeviceTextField.widthAnchor.constraint(equalToConstant: screenW / 2 - 15).isActive = true

        passwordDeviceLabel.topAnchor.constraint(equalTo: imeiDeviceLabel.bottomAnchor, constant: 30).isActive = true
        passwordDeviceLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10).isActive = true

        passwordDeviceTextField.centerYAnchor.constraint(equalTo: passwordDeviceLabel.centerYAnchor).isActive = true
        passwordDeviceTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15).isActive = true
        passwordDeviceTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordDeviceTextField.widthAnchor.constraint(equalToConstant: screenW / 2 - 15).isActive = true
        
        checkBox.topAnchor.constraint(equalTo: passwordDeviceLabel.bottomAnchor, constant: 30).isActive = true
        checkBox.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 20).isActive = true

        saveLabel.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor).isActive = true
        saveLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 10).isActive = true

        
        infoLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15).isActive = true
        infoLabel.topAnchor.constraint(equalTo: passwordDeviceTextField.bottomAnchor, constant: 22).isActive = true

        
        backgroundView.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: screenW / 1.5).isActive = true

    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
}
