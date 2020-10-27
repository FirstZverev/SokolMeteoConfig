//
//  AccountEnter.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 27.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class AccountEnterController: UIViewController {
    
    let customNavigationBar = createCustomNavigationBar(title: "ВХОД В УЧЕТНУЮ ЗАПИСЬ",fontSize: screenW / 22)
    
    lazy var stackTextField: UIStackView = {
        let stackTextField = UIStackView()
        stackTextField.translatesAutoresizingMaskIntoConstraints = false
        stackTextField.axis = .vertical
        stackTextField.spacing = 30
        return stackTextField
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
        let textField = TextFieldWithPadding(placeholder: "Введите IMEI")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        textField.keyboardType = .numberPad
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "Установите пароль")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
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
        button.setTitle("Войти", for: .normal)
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
        print("tap")
        navigationController?.pushViewController(DownloadDaraController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.sv(
            customNavigationBar
        )
        showView()
        delegateTextFieldDelegate()
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

extension AccountEnterController: UITextFieldDelegate {
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
        checkMaxLength(textField: textField, maxLength: 15)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
}
