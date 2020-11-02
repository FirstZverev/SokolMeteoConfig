//
//  AccountEditController.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 30.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import NVActivityIndicatorView

class AccountEditController: UIViewController {
    
    let customNavigationBar = createCustomNavigationBar(title: "ИЗМЕНИТЬ УЧЕТНУЮ ЗАПИСЬ",fontSize: screenW / 22)
    let realm: Realm = {
        return try! Realm()
    }()
    lazy var stackTextField: UIStackView = {
        let stackTextField = UIStackView()
        stackTextField.translatesAutoresizingMaskIntoConstraints = false
        stackTextField.axis = .vertical
        stackTextField.spacing = 30
        return stackTextField
    }()
    
    lazy var viewAlpha: UIView = {
        let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return viewAlpha
    }()
    lazy var activityIndicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .zero, type: .ballGridPulse, color: UIColor.purple)
        view.frame.size = CGSize(width: 50, height: 50)
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.center = viewAlpha.center
        return view
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
    lazy var IMEITextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "Введите e-mail")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.1
        textField.autocapitalizationType = .none
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "Введите пароль")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(self.textFieldPasswordDidMax(_:)),for: UIControl.Event.editingChanged)
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        textField.keyboardType = .numberPad
        return textField
    }()
    lazy var nameDevice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Medium", size: screenW / 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "sokolmeteo.com"
        return label
    }()
    
    var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = UIColor(rgb: 0xBE449E)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionSave), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }
    
    @objc func actionSave() {
        if Reachability.isConnectedToNetwork(){
            viewAlpha.isHidden = false
            fetchInAccount()
        } else {
            showToast(message: "Проверьте соединение", seconds: 1.0)
        }
    }
    fileprivate func realmSave() {
        do {
            let config = Realm.Configuration(
                schemaVersion: 0,
                
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {
                    }
                })
            Realm.Configuration.defaultConfiguration = config
            print(Realm.Configuration.defaultConfiguration.fileURL!)

            let account = AccountModel()
            account.user = IMEITextField.text
            account.password = passwordTextField.text
            
            let realmCheck = realm.objects(AccountModel.self)
            if realmCheck.count != 0 {
                try! realm.write {
                    realmCheck.setValue(account.user, forKey: "user")
                    realmCheck.setValue(account.password, forKey: "password")
                }
            } else {
                try realm.write {
                    realm.add(account)
                }
            }
            //            let workouts = realm.objects(BoxModel.self).filter("time != '0'")
            //            try! realm.write {
            //                workouts.setValue("0", forKey: "time")
            //            }
            
        } catch {
            print("error getting xml string: \(error)")
        }
    }
    
    func fetchInAccount() {
        let urlMain = "http://185.27.193.112:8004"
        let urlString = urlMain + "/login?credentials=\(base64Encoded(email: IMEITextField.text ?? "", password: passwordTextField.text ?? ""))"
        print(urlString)
        let request = AF.request(urlString)
            .validate()
            .responseDecodable(of: Network.self) { (response) in
//                guard let network = response.value else {return}
//                print(network.timestamp!)
            }
        // 2
        request.responseDecodable(of: Network.self) { (response) in
          guard let network = response.value else { return }
            print(network)
            if network.state == "OK" {
                self.realmSave()
                self.viewAlpha.isHidden = true
                self.navigationController?.popViewController(animated: true)
            } else {
                self.viewAlpha.isHidden = true
                self.showToast(message: network.errors?.first ?? "Ошибка", seconds: 1.0)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let realmCheck = realm.objects(AccountModel.self)
        if realmCheck.count != 0 {
            IMEITextField.text = realmCheck[0].user
            passwordTextField.text = realmCheck[0].password
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.sv(
            customNavigationBar
        )
        showView()
        delegateTextFieldDelegate()
        viewAlpha.isHidden = true
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(viewAlpha)
    }
    
    func showView() {
        backView.tintColor = .black
        view.addSubview(backView)
        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        stackTextField.addArrangedSubview(IMEITextField)
        stackTextField.addArrangedSubview(passwordTextField)

        view.sv(stackTextField, nameDevice, saveButton)
        
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        IMEITextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackTextField.widthAnchor.constraint(equalToConstant: screenW - 40).isActive = true
        
        nameDevice.bottomAnchor.constraint(equalTo: stackTextField.topAnchor, constant: -50).isActive = true
        nameDevice.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: screenW / 2.5).isActive = true

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension AccountEditController: UITextFieldDelegate {
    func delegateTextFieldDelegate() {
        passwordTextField.delegate = self
        IMEITextField.delegate = self
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
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
    }
    @objc func textFieldDidMax(_ textField: UITextField) {
        print(textField.text!)
        textField.text = textField.text?.lowercased()
        if textField.text?.last == " " {
            textField.text?.removeLast()
        }
        checkMaxLength(textField: textField, maxLength: 55)
    }
    @objc func textFieldPasswordDidMax(_ textField: UITextField) {
        print(textField.text!)
        if textField.text?.last == " " {
            textField.text?.removeLast()
        }
        checkMaxLength(textField: textField, maxLength: 15)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
}
