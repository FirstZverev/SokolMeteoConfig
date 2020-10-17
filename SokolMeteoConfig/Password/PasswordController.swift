//
//  PasswordController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 24.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import MXSegmentedControl

class PasswordController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    var delegatePassword: PasswordDelegate?
    fileprivate lazy var segmentedControl1: UISegmentedControl = {
        let segmentedControl1 = UISegmentedControl(items: ["Пользовательский","Сервисный"])
        segmentedControl1.selectedSegmentIndex = 0
        segmentedControl1.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl1.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        if #available(iOS 13.0, *) {
            segmentedControl1.selectedSegmentTintColor = .white
        } else {
            segmentedControl1.backgroundColor = .white
            segmentedControl1.tintColor = UIColor(rgb: 0xBE449E)
            segmentedControl1.layer.cornerRadius = 10
        }
        return segmentedControl1
    }()
    
    fileprivate lazy var segmentedControl2: MXSegmentedControl = {
        let passwordFirst = MXSegmentedControl()
        passwordFirst.append(title: "First")
        passwordFirst.append(title: "Second")
        passwordFirst.append(title: "Third")
        passwordFirst.translatesAutoresizingMaskIntoConstraints = false
        return passwordFirst
    }()
    fileprivate lazy var passwordFirst: UILabel = {
        let passwordFirst = UILabel()
        passwordFirst.text = "Сменить ПОЛЬЗОВАТЕЛЬСКИЙ пароль на метеостанции"
        passwordFirst.textColor = .black
        passwordFirst.numberOfLines = 0
        passwordFirst.font = UIFont(name:"FuturaPT-Medium", size: screenW / 20)
        return passwordFirst
    }()
    fileprivate lazy var passwordFirstService: UILabel = {
        let passwordFirst = UILabel()
        passwordFirst.text = "Сменить СЕРВИСНЫЙ пароль на метеостанции"
        passwordFirst.textColor = .black
        passwordFirst.numberOfLines = 0
        passwordFirst.font = UIFont(name:"FuturaPT-Medium", size: screenW / 20)
        return passwordFirst
    }()
    
    fileprivate func registerDelegateTextFields() {
        passwordFieldThreed.delegate = self
        passwordFieldSecond.delegate = self
        passwordFieldThreedService.delegate = self
        passwordFieldSecondService.delegate = self

    }
    
    fileprivate lazy var passwordSecond: UILabel = {
        let password = UILabel()
        password.text = "Старый пароль"
        password.sizeToFit()
        password.numberOfLines = 0
        password.translatesAutoresizingMaskIntoConstraints = false
        password.textColor = .black
        password.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        return password
    }()
    
    fileprivate lazy var passwordThreed: UILabel = {
        let password = UILabel()
        password.text = "Новый пароль"
        password.sizeToFit()
        password.numberOfLines = 0
        password.translatesAutoresizingMaskIntoConstraints = false
        password.textColor = .black
        password.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        return password
    }()
    
    fileprivate lazy var passwordFour: UILabel = {
        let password = UILabel()
        password.text = "Еще раз новый пароль"
        password.sizeToFit()
        password.numberOfLines = 0
        password.translatesAutoresizingMaskIntoConstraints = false
        password.textColor = .black
        password.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        return password
    }()
    
    fileprivate lazy var passwordThreedService: UILabel = {
        let password = UILabel()
        password.text = "Новый пароль"
        password.sizeToFit()
        password.numberOfLines = 0
        password.translatesAutoresizingMaskIntoConstraints = false
        password.textColor = .black
        password.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        return password
    }()
    
    fileprivate lazy var passwordFourService: UILabel = {
        let password = UILabel()
        password.text = "Еще раз новый пароль"
        password.sizeToFit()
        password.numberOfLines = 0
        password.translatesAutoresizingMaskIntoConstraints = false
        password.textColor = .black
        password.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        return password
    }()
    
    fileprivate lazy var passwordFieldFirst: UITextField = {
        let input = TextFieldWithPadding(placeholder: "Введите значение...")
        input.text = mainPassword
        input.isSecureTextEntry = true
        input.translatesAutoresizingMaskIntoConstraints = false
        input.keyboardAppearance = .light
        input.keyboardType = UIKeyboardType.numberPad
        input.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    
    fileprivate lazy var passwordFieldSecond: UITextField = {
        let input = TextFieldWithPadding(placeholder: "Введите значение...")
        input.isSecureTextEntry = true
        input.keyboardAppearance = .light
        input.translatesAutoresizingMaskIntoConstraints = false
        input.keyboardType = UIKeyboardType.numberPad
        input.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    
    fileprivate lazy var passwordFieldThreed: UITextField = {
        let input = TextFieldWithPadding(placeholder: "Введите значение...")
        input.isSecureTextEntry = true
        input.keyboardAppearance = .light
        input.translatesAutoresizingMaskIntoConstraints = false
        input.keyboardType = UIKeyboardType.numberPad
        input.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    
    fileprivate lazy var passwordFieldSecondService: UITextField = {
        let input = TextFieldWithPadding(placeholder: "Введите значение...")
        input.isSecureTextEntry = true
        input.keyboardAppearance = .light
        input.translatesAutoresizingMaskIntoConstraints = false
        input.keyboardType = UIKeyboardType.numberPad
        input.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    
    fileprivate lazy var passwordFieldThreedService: UITextField = {
        let input = TextFieldWithPadding(placeholder: "Введите значение...")
        input.isSecureTextEntry = true
        input.keyboardAppearance = .light
        input.translatesAutoresizingMaskIntoConstraints = false
        input.keyboardType = UIKeyboardType.numberPad
        input.font = UIFont(name:"FuturaPT-Light", size: screenW / 22)
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    @objc func textFieldDidMax(_ textField: UITextField) {
        print(textField.text!)
        checkMaxLength(textField: textField, maxLength: 10)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate lazy var passwordSet: UIButton = {
        let btn = UIButton(frame: CGRect(x: 30, y: Int(screenH) - 100, width: Int(screenW / 2), height: 44))
        btn.center.x = screenW / 2
        btn.backgroundColor = UIColor(rgb: 0xBE449E)
        btn.layer.cornerRadius = 20
        btn.setTitle("Установить", for: .normal)
        btn.titleLabel?.font = UIFont(name: "FuturaPT-Medium", size: screenW / 20)
        btn.addTarget(self, action: #selector(tapPasswordSet), for: .touchUpInside)
        return btn
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
    
    lazy var passwordView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        view.layer.shadowRadius = 4.0
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var passwordViewService: UIView = {
        let view = UIView(frame: CGRect(x: screenW, y: 10, width: screenW - 40, height: 232))
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        view.layer.shadowRadius = 4.0
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.hero.isEnabled = true
        scrollView.delegate = self
        let customNavigationBar = createCustomNavigationBar(title: "ПАРОЛЬ",fontSize: screenW / 22)
        customNavigationBar.hero.id = "PasswordToMeteo"


        view.sv(customNavigationBar, scrollView)
        registerDelegateTextFields()
        showView()
        
    }
    
    func showView() {
        view.addSubview(passwordSet)
        backView.tintColor = .black
        view.addSubview(backView)
        view.addSubview(segmentedControl1)
        
        segmentedControl1.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 + 5).isActive = true
        segmentedControl1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl1.widthAnchor.constraint(equalToConstant: screenW - 10).isActive = true
        segmentedControl1.heightAnchor.constraint(equalToConstant: screenH / 20).isActive = true

        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        scrollView.topAnchor.constraint(equalTo: segmentedControl1.bottomAnchor, constant: 10).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
        scrollView.contentSize = CGSize(width: Int(screenW * 2 - 20), height: Int(screenH) / 2)
        
        scrollView.sv(passwordView)
        passwordView.sv(passwordFirst, passwordThreed, passwordFour, passwordFieldSecond, passwordFieldThreed)
        
        passwordView.width(screenW - 40).left(10).topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        passwordView.bottomAnchor.constraint(equalTo: passwordFieldThreed.bottomAnchor, constant: 20).isActive = true
        
        passwordFirst.left(10).right(10).topAnchor.constraint(equalTo: passwordView.topAnchor, constant: 15).isActive = true

        passwordFieldSecond.height(50).right(10).topAnchor.constraint(equalTo: passwordFirst.bottomAnchor, constant: 30).isActive = true
        passwordFieldSecond.leadingAnchor.constraint(equalTo: passwordThreed.trailingAnchor, constant: 10).isActive = true

        passwordThreed.left(10).centerYAnchor.constraint(equalTo: passwordFieldSecond.centerYAnchor).isActive = true

        passwordFieldThreed.height(50).right(10).topAnchor.constraint(equalTo: passwordFieldSecond.bottomAnchor, constant: 20).isActive = true
        passwordFieldThreed.leadingAnchor.constraint(equalTo: passwordFour.trailingAnchor, constant: 10).isActive = true

        passwordFour.left(10).centerYAnchor.constraint(equalTo: passwordFieldThreed.centerYAnchor).isActive = true

//        passwordFour.backgroundColor = .green
        scrollView.addSubview(passwordViewService)
        passwordViewService.sv(passwordFirstService, passwordThreedService, passwordFourService, passwordFieldSecondService, passwordFieldThreedService)

        passwordFirstService.left(10).right(10).topAnchor.constraint(equalTo: passwordViewService.topAnchor, constant: 15).isActive = true

        passwordFieldSecondService.height(50).right(10).topAnchor.constraint(equalTo: passwordFirstService.bottomAnchor, constant: 30).isActive = true
        passwordFieldSecondService.leadingAnchor.constraint(equalTo: passwordThreedService.trailingAnchor, constant: 10).isActive = true

        passwordThreedService.left(10).centerYAnchor.constraint(equalTo: passwordFieldSecondService.centerYAnchor).isActive = true

        passwordFieldThreedService.height(50).right(10).topAnchor.constraint(equalTo: passwordFieldSecondService.bottomAnchor, constant: 20).isActive = true
        passwordFieldThreedService.leadingAnchor.constraint(equalTo: passwordFourService.trailingAnchor, constant: 10).isActive = true

        passwordFourService.left(10).centerYAnchor.constraint(equalTo: passwordFieldThreedService.centerYAnchor).isActive = true
//        passwordViewService.width(screenW - 40).topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
//        passwordViewService.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
//        passwordViewService.bottomAnchor.constraint(equalTo: passwordSet.bottomAnchor, constant: 20).isActive = true


        
        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        scrollView.addTapGesture {
            self.scrollView.endEditing(true)
        }
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
    
    @objc func tapPasswordSet() {
        reload = 25 + segmentedControl1.selectedSegmentIndex
        newPassword = ((segmentedControl1.selectedSegmentIndex == 0) ? passwordFieldSecond.text ?? "" : passwordFieldSecondService.text ?? "")
        delegatePassword?.buttonTapPassword()
    }
    override func viewWillAppear(_ animated: Bool) {
        reload = 27
        self.delegatePassword?.buttonTapPassword()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
        let w = scrollView.frame.size.width
        let page = scrollView.contentOffset.x / w
        segmentedControl1.selectedSegmentIndex = Int(round(page))
        passwordSet.backgroundColor = .lightGray
        passwordSet.isEnabled = false
        print(page)
        if page >= 1 || page <= 0 {
            passwordSet.backgroundColor = UIColor(rgb: 0xBE449E)
            passwordSet.isEnabled = true
        }
    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let w = scrollView.frame.size.width
//        let page = scrollView.contentOffset.x / w
//        scrollView.setContentOffset(CGPoint(x: Int(scrollView.frame.size.width + 20) * Int(round(page)), y: 0), animated: true)
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let w = scrollView.frame.size.width
//        let page = scrollView.contentOffset.x / w
//        scrollView.setContentOffset(CGPoint(x: Int(scrollView.frame.size.width + 20) * Int(round(page)), y: 0), animated: true)
//    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        let x = scrollView.frame.size.width * CGFloat(sender.selectedSegmentIndex)
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
}
