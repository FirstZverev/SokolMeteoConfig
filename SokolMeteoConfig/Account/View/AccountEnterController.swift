//
//  AccountEnter.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 27.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import NVActivityIndicatorView
import SimpleCheckbox

class AccountEnterController: UIViewController {
    
    var tagSelectProfile = 0
    var pushAccountProfile = false
    let tabBarSokolMeteoVC = TabBarSokolMeteoController()
    let customNavigationBar = createCustomNavigationBar(title: "ВХОД В УЧЕТНУЮ ЗАПИСЬ",fontSize: screenW / 22)
    let profileSelect = ProfileSelectController()
    var viewModel: ServiceModel = ServiceModel()
    var initialY: CGFloat!
    let networkManager = NetworkManager()

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
    lazy var alertView: CustomAlert = {
        let alertView: CustomAlert = CustomAlert.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
       let view = UIVisualEffectView(effect: blurEffect)
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        label.font = UIFont(name:"FuturaPT-Light", size: screenW / 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Запомнить"
        return label
    }()

    var profileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать профиль", for: .normal)
        button.backgroundColor = UIColor(rgb: 0xBE449E)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(profileAction), for: .touchUpInside)
        return button
    }()
    @objc func profileAction() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        profileSelect.pushAccount = true
        navigationController?.pushViewController(profileSelect, animated: true)
    }
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
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = UIColor(rgb: 0xBE449E)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionSave), for: .touchUpInside)
        return button
    }()
    var registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрировать аккаунт", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x998F99), for: .normal)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionRegister), for: .touchUpInside)
        return button
    }()
    
    var fogetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x998F99), for: .normal)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionFoget), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewDidDisappear(_ animated: Bool) {

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
    
    @objc func checkboxValueChanged(sender: Checkbox!) {
        checkBoxSender()
    }
    @objc func actionRegister() {
        self.navigationController?.pushViewController(RegistrationController(), animated: true)
    }
    @objc func actionFoget() {
        setAlert()
        animateIn()
    }
    @objc func actionSave() {
        if Reachability.isConnectedToNetwork(){
            viewAlpha.isHidden = false
//            fetchInAccount()
            let userData = ["login": "\(IMEITextField.text ?? "")", "password": "\(passwordTextField.text ?? "")"]
            networkingPostRequest(urlString: "http://185.27.193.112:8004/auth/login", userDataJSON: userData) { (id, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.viewAlpha.isHidden = true
                        self.showToast(message: error!, seconds: 1.0)
                    }
                }
                guard let id = id else { return }
                idSession = id
                if devicesList.count != 0 {
                    DispatchQueue.main.async {
                        devicesList.removeAll()
                        self.tabBarSokolMeteoVC.firstVC.updateItemTableView()
                    }
                }
                DispatchQueue.main.async { [self] in
                    viewModel.sokolTemplateInfo = ["Не выбрано", "Не выбрано"]
                    tabBarSokolMeteoVC.secondVC.viewModel = viewModel
                    tabBarSokolMeteoVC.firstVC.tagSelectProfile = tagSelectProfile
                    navigationController?.pushViewController(tabBarSokolMeteoVC, animated: true )
                }
            }
        } else {
            showToast(message: "Проверьте соединение", seconds: 1.0)
        }
    }
    fileprivate func realmSave() {
            var config = Realm.Configuration(
                schemaVersion: 2,
                
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 2) {
                    }
                })
            config.deleteRealmIfMigrationNeeded = true

            Realm.Configuration.defaultConfiguration = config
            print(Realm.Configuration.defaultConfiguration.fileURL!)

            let account = AccountModel()
            account.user = IMEITextField.text
            account.password = passwordTextField.text
            if checkBox.isChecked == true {
                account.save = true
            } else {
                account.save = false
            }
            let realm: Realm = {
                return try! Realm()
            }()
            
            let realmCheck = realm.objects(AccountModel.self)
            if realmCheck.count != 0 {
                try! realm.write {
                    if realmCheck.count == 1 {
                        realmCheck[0].setValue(false, forKey: "save")
                    } else {
                        for i in 0...realmCheck.count - 1 {
                            realmCheck[i].setValue(false, forKey: "save")
                        }
                    }
                }
            }
            let realmboxing = realm.objects(AccountModel.self).filter("user = %@", account.user!)

            if realmboxing.count != 0 {
                tagSelectProfile = realmboxing[0].id
                try! realm.write {
                    realmboxing.setValue(account.user, forKey: "user")
                    realmboxing.setValue(account.password, forKey: "password")
                    realmboxing.setValue(account.save, forKey: "save")
                }
            } else {
                do {
                    tagSelectProfile = realmCheck.count
                    account.id = realmCheck.count
                    try realm.write {
                        realm.add(account)
                    }
                } catch {
                    print("error getting xml string: \(error)")
                }
            }
            //            let workouts = realm.objects(BoxModel.self).filter("time != '0'")
            //            try! realm.write {
            //                workouts.setValue("0", forKey: "time")
            //            }
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
//                self.navigationController?.pushViewController(DownloadDaraController(), animated: true)
            } else {
                self.viewAlpha.isHidden = true
                self.showToast(message: network.errors?.first ?? "Ошибка", seconds: 1.0)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        var config = Realm.Configuration(
            schemaVersion: 2,
            
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 2) {
                }
            })
        config.deleteRealmIfMigrationNeeded = true

        Realm.Configuration.defaultConfiguration = config
        
        let realm: Realm = {
            return try! Realm()
        }()
        
        if pushAccountProfile {
            let realmCheck = realm.objects(AccountModel.self)
            if realmCheck.count != 0 {
                IMEITextField.text = realmCheck[tagSelectProfile].user
                passwordTextField.text = realmCheck[tagSelectProfile].password
                checkBox.isChecked = realmCheck[tagSelectProfile].save
                checkBoxSender()
                profileButton.alpha = 1.0
                profileButton.isEnabled = true
            } else {
                profileButton.alpha = 0.4
                profileButton.isEnabled = false
                checkBox.isChecked = false
                checkBoxSender()
            }
        } else {
            let realmboxing = realm.objects(AccountModel.self).filter("save = %@", true)
            if realmboxing.count == 1 {
                if realmboxing.count != 0 {
                    IMEITextField.text = realmboxing[0].user
                    passwordTextField.text = realmboxing[0].password
                    checkBox.isChecked = realmboxing[0].save
                    checkBoxSender()
                    profileButton.alpha = 1.0
                    profileButton.isEnabled = true
                } else {
                    profileButton.alpha = 0.4
                    profileButton.isEnabled = false
                    checkBox.isChecked = false
                    checkBoxSender()
                }
            } else {
                profileButton.alpha = 0.4
                profileButton.isEnabled = false
            }

        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            initialY = alertView.frame.origin.y
            alertView.center.y = (screenH - CGFloat(keyboardSize.height)) / 2
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        alertView.frame.origin.y = initialY
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.CustomTextField.delegate = self
        initialY = alertView.frame.origin.y
        view.backgroundColor = .white
        view.sv(
            customNavigationBar
        )
        customNavigationBar.hero.id = "PlatformaSokol"
        showView()
        delegateTextFieldDelegate()
        viewAlpha.isHidden = true
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(viewAlpha)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func networkingPostRequest(urlString: String, userDataJSON: [String: String], completion: @escaping (_ photoFormat: String?,_ error: String?) -> () ) {
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userDataJSON, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let stringError = error?.localizedDescription {
                completion(nil, stringError)
            }
            guard let response = response, let data = data else { return }
            print(response)
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                let jsonSecond = try JSONDecoder().decode(MessageError.self, from: data)
                print(jsonSecond)
                if let error = jsonSecond.localMessage {
                    DispatchQueue.main.async {
                        self.viewAlpha.isHidden = true
                        self.showToast(message: error, seconds: 1.0)
                    }
                }
                guard let JSESSIONID = jsonSecond.result else {return}
                if jsonSecond.state == "OK" {
                    DispatchQueue.main.async {
                        self.realmSave()
                        self.viewAlpha.isHidden = true
                    }
                } else {

                }
                completion(JSESSIONID, nil)
            } catch {
                print("\(error)")
                completion(nil, NetworkResponse.unableToDecode.rawValue)
            }
        }.resume()
    }
    
    func showView() {
        backView.tintColor = .black
        view.addSubview(backView)
        backView.addTapGesture {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        stackTextField.addArrangedSubview(IMEITextField)
        stackTextField.addArrangedSubview(passwordTextField)
        stackTextField.addArrangedSubview(saveTextField)

        saveTextField.addArrangedSubview(checkBox)
        saveTextField.addArrangedSubview(saveLabel)
        
        view.sv(stackTextField, nameDevice, saveButton, profileButton, registrationButton, fogetButton)
        
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        IMEITextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        checkBox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 20).isActive = true

        stackTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackTextField.widthAnchor.constraint(equalToConstant: screenW - 40).isActive = true
        
        nameDevice.bottomAnchor.constraint(equalTo: stackTextField.topAnchor, constant: -50).isActive = true
        nameDevice.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: screenW / 4).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: screenW / 2.2).isActive = true
        
        profileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -screenW / 4).isActive = true
        profileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: screenW / 2.2).isActive = true

        registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registrationButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        registrationButton.widthAnchor.constraint(equalToConstant: screenW / 1.5).isActive = true
        
        fogetButton.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor).isActive = true
        fogetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
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
        checkMaxLength(textField: textField, maxLength: 50)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
}
