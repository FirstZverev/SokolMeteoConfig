//
//  ConfiguratorFirstController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 16.06.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class ConfiguratorFirstController : UIViewController {
    
    var constraints: [NSLayoutConstraint] = []
    var constraints2: [NSLayoutConstraint] = []
    var delegate: FirstConfiguratorDelegate?
    var timer = Timer()

    lazy var pickerChanel: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        picker.clipsToBounds = true
        picker.layer.cornerRadius = 20
        picker.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        picker.isHidden = true
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        toolBar.isUserInteractionEnabled = true
        
        chanelTextField.inputView = picker
        chanelTextField.inputAccessoryView = toolBar

        return picker
    }()
    
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
    lazy var settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Настройки GSM"
        label.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        label.textColor = .black
        return label
    }()
    
    lazy var settingsServerLabel: UILabel = {
        let label = UILabel()
        label.text = "Настройки Сервера"
        label.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        label.textColor = .black
        return label
    }()
    
    lazy var accessPointLabel: UILabel = {
        let label = UILabel()
        label.text = "Точка доступа"
        label.sizeToFit()
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользователь"
        label.sizeToFit()
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль"
        label.sizeToFit()
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var pinLabel: UILabel = {
        let label = UILabel()
        label.text = "Пин код SIM"
        label.sizeToFit()
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Адрес"
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var portLabel: UILabel = {
        let label = UILabel()
        label.text = "Порт"
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var passwordDevicesLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль доступа к устройству"
        label.numberOfLines = 0
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var periodPushLabel: UILabel = {
        let label = UILabel()
        label.text = "Период отпр. параметров мин."
        label.numberOfLines = 0
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var periodRequestLabel: UILabel = {
        let label = UILabel()
        label.text = "Период запр. БМВД"
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var channelLabel: UILabel = {
        let label = UILabel()
        label.text = "Канал передачи данных"
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var BMVDLabel: UILabel = {
        let label = UILabel()
        label.text = "Взаимодействие с беспроводным модулем"
        label.numberOfLines = 0
        label.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        label.textColor = .black
        return label
    }()
    
    lazy var periodExchangeLabel: UILabel = {
        let label = UILabel()
        label.text = "Период обмена"
        label.sizeToFit()
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "Номер частотного канала связи"
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var accessPointTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "m2m.beline.ru")
        return textField
    }()
    lazy var userTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "m2m.beline.ru")
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "**********")
        return textField
    }()
    
    lazy var pinTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "1234")
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var addressTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "m2m.beline.ru")
        return textField
        
    }()
    lazy var portTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "m2m.beline.ru")
        return textField
    }()
    
    lazy var passwordDevicesTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "m2m.beline.ru")
        return textField
    }()
    
    lazy var periodTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "10...59 мин")
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var periodEchangeTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "5 минут")
        return textField
    }()
    
    lazy var numberTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "0 канал")
        return textField
    }()
    
    lazy var chanelTextField: UITextField = {
        let textField = TextFieldWithPadding(placeholder: "")
        textField.text = "GSM"
        textField.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImageView(image: UIImage(named: "arrow_drop_down_24px"))
        image.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(image)
        image.width(30).height(30).topAnchor.constraint(equalTo: textField.topAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
        return textField
    }()
    lazy var chanelView: UIView = {
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
    lazy var gsmView: UIView = {
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
    
    lazy var serverView: UIView = {
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
    
    lazy var dopView: UIView = {
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
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    lazy var blurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.0
        blurEffectView.isHidden = true
        return blurEffectView
    }()
}
