//
//  RegistrationController.swift
//  SOKOL
//
//  Created by Володя Зверев on 13.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RegistrationController: UIViewController {
    
    let customNavigationBar = createCustomNavigationBar(title: "РЕГИСТРАЦИЯ",fontSize: screenW / 22)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var stackTextField: UIStackView = {
        let stackTextField = UIStackView()
        stackTextField.translatesAutoresizingMaskIntoConstraints = false
        stackTextField.axis = .vertical
        stackTextField.spacing = 30
        return stackTextField
    }()
    
    lazy var saveTextField: UIStackView = {
        let stackTextField = UIStackView()
        stackTextField.translatesAutoresizingMaskIntoConstraints = false
        stackTextField.axis = .horizontal
        stackTextField.spacing = 15
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
    lazy var firstNameTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "Введите имя")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.1
        textField.autocapitalizationType = .none
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        return textField
    }()
    lazy var secondNameTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "Введите фамилию")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.1
        textField.autocapitalizationType = .none
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        return textField
    }()
    lazy var thriedNameTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "Введите отчество")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.1
        textField.autocapitalizationType = .none
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        return textField
    }()
    lazy var emailTextField: UITextField = {
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
        textField.addTarget(self, action: #selector(self.textFieldPasswordDidMax(_:)),for: UIControl.Event.editingChanged)
        textField.isSecureTextEntry = true
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        return textField
    }()
    
    lazy var passwordRepeatTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "Повторите пароль")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(self.textFieldPasswordDidMax(_:)),for: UIControl.Event.editingChanged)
        textField.isSecureTextEntry = true
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        return textField
    }()
    lazy var nameDevice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Medium", size: screenW / 14)
        label.textColor = UIColor(rgb: 0xBE449E)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "sokolmeteo.com"
        return label
    }()
    
    var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = UIColor(rgb: 0xBE449E)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionSave), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }
    
    @objc func actionSave() {
        if passwordTextField.text == passwordRepeatTextField.text {
            if Reachability.isConnectedToNetwork(){
                viewAlpha.isHidden = false
                let userRegister = RegisterData(email: emailTextField.text!, password: passwordTextField.text!, name: firstNameTextField.text!, surname: secondNameTextField.text!)
                
                RegisterViewModel.registration(user: userRegister) { (message) in
                    DispatchQueue.main.async {
                        self.viewAlpha.isHidden = true
                    }
                    if message == "OK" {
                        DispatchQueue.main.async {
                            self.showToast(message: "Ссылку для активации отправлена на \(self.emailTextField.text!)", seconds: 1.0)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showToast(message: message, seconds: 1.0)
                        }
                    }
                }
            } else {
                showToast(message: "Проверьте соединение", seconds: 1.0)
            }
        } else {
            showToast(message: "Пароли не совпадают", seconds: 1.0)
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.sv(scrollView, customNavigationBar)
        customNavigationBar.hero.id = "PlatformaSokol"
        showView()
        delegateTextFieldDelegate()
        viewAlpha.isHidden = true
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(viewAlpha)
        registerKeyboardNotification()
    }
    
    func showView() {
        backView.tintColor = .black
        view.addSubview(backView)
        backView.addTapGesture {
            self.navigationController?.popViewController(animated: true)
        }
        stackTextField.addArrangedSubview(firstNameTextField)
        stackTextField.addArrangedSubview(secondNameTextField)
        stackTextField.addArrangedSubview(thriedNameTextField)
        stackTextField.addArrangedSubview(emailTextField)
        stackTextField.addArrangedSubview(passwordTextField)
        stackTextField.addArrangedSubview(passwordRepeatTextField)
        stackTextField.addArrangedSubview(saveTextField)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenW / 12).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.contentSize = CGSize(width: Int(screenW), height: Int(screenH))

        scrollView.sv(stackTextField, nameDevice, saveButton)
        
        firstNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        secondNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        thriedNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordRepeatTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        stackTextField.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        stackTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackTextField.widthAnchor.constraint(equalToConstant: screenW - 40).isActive = true
        
        nameDevice.bottomAnchor.constraint(equalTo: stackTextField.topAnchor, constant: -50).isActive = true
        nameDevice.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        saveButton.topAnchor.constraint(equalTo: stackTextField.bottomAnchor, constant: 20).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: screenW / 1.5).isActive = true
        scrollView.addTapGesture {
            self.scrollView.endEditing(true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension RegistrationController: UITextFieldDelegate {
    func delegateTextFieldDelegate() {
        firstNameTextField.delegate = self
        secondNameTextField.delegate = self
        thriedNameTextField.delegate = self

        passwordRepeatTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
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
        if textField.text?.last == " " {
            textField.text?.removeLast()
        }
        checkMaxLength(textField: textField, maxLength: 55)
    }
    @objc func textFieldPasswordDidMax(_ textField: UITextField) {
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
    
    fileprivate func registerKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
                scrollView.contentInset = contentInset
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)

        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}
