//
//  PasswordController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 24.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class PasswordController: UIViewController {
    
    fileprivate lazy var passwordFirst: UILabel = {
        let passwordFirst = UILabel(frame: CGRect(x: 30, y: 110, width: screenW - 50, height: 50))
        passwordFirst.text = "Сменить пароль на метеостанции"
        passwordFirst.textColor = .black
        passwordFirst.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        return passwordFirst
    }()
    
    fileprivate lazy var passwordSecond: UILabel = {
        let password = UILabel(frame: CGRect(x: 30, y: 165, width: screenW - 50, height: 40))
        password.text = "Старый пароль"
        password.textColor = .black
        password.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return password
    }()
    
    fileprivate lazy var passwordThreed: UILabel = {
        let password = UILabel(frame: CGRect(x: 30, y: 225, width: screenW - 50, height: 40))
        password.text = "Новый пароль"
        password.textColor = .black
        password.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return password
    }()
    
    fileprivate lazy var passwordFour: UILabel = {
        let password = UILabel(frame: CGRect(x: 30, y: 285, width: screenW - 50, height: 40))
        password.text = "Еще раз новый пароль"
        password.textColor = .black
        password.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return password
    }()
    
    fileprivate lazy var passwordFieldFirst: UITextField = {
        let input = UITextField(frame: CGRect(x: Int(screenW / 2), y: 160, width: Int(screenW / 2 - 30), height: 40))
        input.text = ""
        input.attributedPlaceholder = NSAttributedString(string: "Введите значение...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.textColor = .black
        input.keyboardAppearance = .alert
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    
    fileprivate lazy var passwordFieldSecond: UITextField = {
        let input = UITextField(frame: CGRect(x: Int(screenW / 2), y: 220, width: Int(screenW / 2 - 30), height: 40))
        input.text = ""
        input.attributedPlaceholder = NSAttributedString(string: "Введите значение...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.textColor = .black
        input.keyboardAppearance = .light
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    
    fileprivate lazy var passwordFieldThreed: UITextField = {
        let input = UITextField(frame: CGRect(x: Int(screenW / 2), y: 280, width: Int(screenW / 2 - 30), height: 40))
        input.text = ""
        input.attributedPlaceholder = NSAttributedString(string: "Введите значение...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.textColor = .black
        input.keyboardAppearance = .dark
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
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
    
    fileprivate lazy var passwordSet: UIView = {
        let btn = UIView(frame: CGRect(x: 30, y: 340, width: Int(screenW - 60), height: 44))
        btn.backgroundColor = UIColor(rgb: 0xCF2121)
        btn.layer.cornerRadius = 22
        
        let btnText = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenW - 60), height: 44))
        btnText.text = "Установить"
        btnText.textColor = .white
        btnText.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btnText.textAlignment = .center
        btn.addSubview(btnText)
        return btn
    }()
    
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: 35, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 15, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height/2
        backView.addSubview(back)
        return backView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let customNavigationBar = createCustomNavigationBar(title: "ПАРОЛЬ",fontSize: 16.0)
        self.hero.isEnabled = true
        customNavigationBar.hero.id = "PasswordToMeteo"


        view.sv(
            customNavigationBar
        )
        showView()
    }
    
    func showView() {
        view.addSubview(passwordFirst)
        view.addSubview(passwordFieldFirst)
        view.addSubview(passwordFieldSecond)
        view.addSubview(passwordFieldThreed)
        view.addSubview(passwordSecond)
        view.addSubview(passwordThreed)
        view.addSubview(passwordFour)
        view.addSubview(passwordSet)
        backView.tintColor = .black
        view.addSubview(backView)
        
        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
