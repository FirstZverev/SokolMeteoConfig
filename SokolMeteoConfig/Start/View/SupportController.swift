//
//  SupportController.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 22.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import FittedSheets

class SupportController: UIViewController {
    
    var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = screenW / 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var whatsappIcon: UIButton = {
        let icon = UIButton()
        icon.setImage(UIImage(named: "cib_whatsapp"), for: .normal)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.addTarget(self, action: #selector(actionWhatsapp), for: .touchUpInside)
        return icon
    }()
    
    var telegramIcon: UIButton = {
        let icon = UIButton()
        icon.setImage(UIImage(named: "cib_telegram"), for: .normal)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.addTarget(self, action: #selector(actionTelegram), for: .touchUpInside)
        return icon
    }()
    
    var viberIcon: UIButton = {
        let icon = UIButton()
        icon.setImage(UIImage(named: "cib_viber"), for: .normal)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.addTarget(self, action: #selector(actionViber), for: .touchUpInside)
        return icon
    }()
    
    @objc func actionWhatsapp() {
        if let url = URL(string:"https://api.whatsapp.com/send?phone=+79600464665") {
            UIApplication.shared.open(url) { success in
                if success {
                    print("success")
                } else {
                    self.showToast(message: "WhatsApp " + "приложение не установлено на этом устройстве", seconds: 1)
                }
            }
        }
    }
    
    @objc func actionViber() {
        if let url = URL(string:"viber://chat?number=+79600464665") {
            UIApplication.shared.open(url) { success in
                if success {
                    print("success")
                } else {
                    self.showToast(message: "Viber " + "приложение не установлено на этом устройстве", seconds: 1)
                }
            }
        }
    }
    
    @objc func actionTelegram() {
        if let url = URL(string:"https://telegram.me/EscortSupport") {
            UIApplication.shared.open(url) { success in
                if success {
                    print("success")
                } else {
                    self.showToast(message: "Telegram " + "приложение не установлено на этом устройстве", seconds: 1)
                }
            }
        }
    }
    override func loadView() {
        super.loadView()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stack.addArrangedSubview(whatsappIcon)
        stack.addArrangedSubview(telegramIcon)
        stack.addArrangedSubview(viberIcon)

        viewShow()
        constrains()
        
        
    }
    
    fileprivate func constrains() {
        view.addSubview(stack)
        stack.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1 / 10).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

//
//        telegramIcon.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1 / 3).isActive = true
//        telegramIcon.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1 / 10).isActive = true
//
//        viberIcon.centerXAnchor.constraint(equalToSystemSpacingAfter: telegramIcon.centerXAnchor, multiplier: 1/2).isActive = true
//        viberIcon.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1 / 10).isActive = true
//
//        whatsappIcon.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1 / 3).isActive = true
//        whatsappIcon.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1 / 10).isActive = true


    }

    override func viewDidAppear(_ animated: Bool) {

    }
    override func viewWillDisappear(_ animated: Bool) {
    }


    private func viewShow() {
//        view.layer.cornerRadius = 35
        view.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.backgroundColor = .white
    }
}
