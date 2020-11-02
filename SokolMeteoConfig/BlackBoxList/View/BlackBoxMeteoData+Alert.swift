//
//  BlackBoxMeteoData+Alert.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 27.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import RealmSwift

extension BlackBoxMeteoDataController: AlertDelegate {
    
    func buttonClose() {
        animateOut()
    }
    func forgotTapped() {
        animateOut()
    }
    
    func buttonTapped() {
        animateOut()
        if alertView.checkBoxOne.isChecked == true {
            let realm: Realm  = {
                return try! Realm()
            }()
            let realmCheck = realm.objects(DeviceNameModel.self).filter("nameDevice = %@", nameDeviceBlackBox ?? "")
            let realmAccount = realm.objects(AccountModel.self)
            if realmCheck.first?.passwordDevice != nil && realmCheck.first?.IMEIDevice != nil {
                if realmAccount.first?.user != nil {
                    createAlertAccount()
                } else {
                    let accountEditVC = AccountEditController()
                    navigationController?.pushViewController(accountEditVC, animated: true)
                }
            } else {
                let profileMeteoVC = ProfileMeteoController()
                profileMeteoVC.deviveNaming = nameDeviceBlackBox
                navigationController?.pushViewController(profileMeteoVC, animated: true)
            }
        } else {
            saveCSV(isShare: true)
        }
    }
    
    func setupVisualEffectView() {
        navigationController?.view.addSubview(visualEffectView)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        visualEffectView.alpha = 0
    }
    
    func setAlert() {
        setupVisualEffectView()
        navigationController?.view.addSubview(alertView)
        alertView.center = view.center
        alertView.set(title: "Способ отправки", body: "", buttonTitle: "Отправить")
    }
    
    func animateIn() {
        alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertView.alpha = 1
            self.alertView.transform = CGAffineTransform.identity
        }
    }
    func animateOut() {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.alertView.alpha = 0
                        self.alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                        self.alertView.removeFromSuperview()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        })
    }
}

extension BlackBoxMeteoDataController: AlertAccountDelegate {
    func buttonAccountFirst() {
        let accountEditVC = AccountEditController()
        navigationController?.pushViewController(accountEditVC, animated: true)
        animateOutAccount()
    }
    
    func buttonAccountSecond() {
        let profileMeteoVC = ProfileMeteoController()
        profileMeteoVC.deviveNaming = nameDeviceBlackBox
        navigationController?.pushViewController(profileMeteoVC, animated: true)
        animateOutAccount()
    }
    
    
    func buttonAccountClose() {
        animateOutAccount()
    }
    
    func buttonAccountTapped() {
        animateOutAccount()
        pushFileServer()
        viewAlpha.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.navigationController?.pushViewController(DownloadDaraController(), animated: true)
            self.viewAlpha.isHidden = true
        })
    }
    
    func setupVisualEffectViewAccount() {
        navigationController?.view.addSubview(visualEffectView)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        visualEffectView.alpha = 0
    }
    
    func setAlertAccount() {
        setupVisualEffectView()
        navigationController?.view.addSubview(alertViewAccount)
        alertViewAccount.center = view.center
        let realm: Realm  = {
           return try! Realm()
        }()
        let realmCheck = realm.objects(DeviceNameModel.self).filter("nameDevice = %@", nameDeviceBlackBox ?? "")
        let realmEmail = realm.objects(AccountModel.self)

        alertViewAccount.set(title: "Учетная запись sokolmeteo.com", nameDevice: (realmCheck.first?.nameDevice) ?? "", labelImei: (realmCheck.first?.IMEIDevice) ?? "", labelPassword: (realmCheck.first?.passwordDevice) ?? "", buttonTitle: "Отправить", labelEmail: realmEmail.first?.user ?? "")
    }
    
    func animateInAccount() {
        alertViewAccount.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertViewAccount.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertViewAccount.alpha = 1
            self.alertViewAccount.transform = CGAffineTransform.identity
        }
    }
    func animateOutAccount() {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.alertViewAccount.alpha = 0
                        self.alertViewAccount.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                        self.alertViewAccount.removeFromSuperview()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        })
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func pushFileServer() {
        var str = "#L#"
        let realm: Realm  = {
           return try! Realm()
        }()
        let realmCheck = realm.objects(BoxModel.self).filter("nameDevice = %@", nameDeviceBlackBox ?? "")
        let realmImei = realm.objects(DeviceNameModel.self).filter("nameDevice = %@", nameDeviceBlackBox ?? "")
        let realmAccount = realm.objects(AccountModel.self)
        
        //            print(realmCheck)
        str += (realmImei.first?.IMEIDevice)! + ";" + (realmImei.first?.passwordDevice)! +  "\n#B#\n"
        for i in 0...realmCheck.count - 1 {
            str += realmCheck[i].allString! + "|\n"
        }
        let fileURL = getDocumentsDirectory().appendingPathComponent("output.txt")

        do {
            try str.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        
        // generate boundary string using a unique string
        let boundary = UUID().uuidString
                 
        // Set the URLRequest to POST and to the specified URL
        let urlMain = "http://185.27.193.112:8004"
        let urlString = urlMain + "/data?credentials=\(base64Encoded(email: realmAccount.first?.user ?? "", password: realmAccount.first?.password ?? ""))&station=\(nameDeviceBlackBox ?? "")&start=\((realmCheck.first?.time)! + "000")&end=\((realmCheck.last?.time)! + "000")"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
//        request.addValue("Bearer \(yourAuthorizationToken)", forHTTPHeaderField: "Authorization")
                 
        // Content-Type is multipart/form-data, this is the same as submitting form data with file upload
        // in a web browser
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                 
        let fileName = fileURL.lastPathComponent
        let mimetype = "text/plain"
        let paramName = "file"
        let fileData = try? Data(contentsOf: fileURL)
        var data = Data()
        // Add the file data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        data.append(fileData!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        // do not forget to set the content-length!
        print("data: \(data)")
        print("data: \(request)")
        request.httpBody = data
        request.setValue(String(data.count), forHTTPHeaderField: "Content-Length")
        let session = URLSession.shared
        let uploadTask = session.uploadTask(with: request as URLRequest, from: data,
                                            completionHandler: { (responseData, response, error) in
                                                
                                                // Check on some response headers (if it's HTTP)
                                                if let httpResponse = response as? HTTPURLResponse {
                                                    switch httpResponse.statusCode {
                                                    case 200..<300:
                                                        print("Success")
                                                    case 400..<500:
                                                        print("Request error")
                                                    case 500..<600:
                                                        print("Server error")
                                                    case let otherCode:
                                                        print("Other code: \(otherCode)")
                                                    }
                                                }
                                                
                                                // Do something with the response data
                                                if let
                                                    responseData = responseData,
                                                   let responseString = String(data: responseData, encoding: String.Encoding.utf8) {
                                                    print("Server Response:")
                                                    print(responseString)
                                                }
                                                
                                                // Do something with the error
                                                if let error = error {
                                                    print(error.localizedDescription)
                                                }
                                            })
        
        uploadTask.resume()
    }
    
}

extension BlackBoxMeteoDataController: ConfirmationAlertDelegate {
    func closeAlertConfirmation() {
        animateOutConfirmation()
    }

    func buttonTappedConfirmation() {
        do {
            let config = Realm.Configuration(
                schemaVersion: 0,
                
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {
                    }
                })
            Realm.Configuration.defaultConfiguration = config
            let realmboxing = realm.objects(BoxModel.self).filter("nameDevice = %@", nameDeviceBlackBox!)
            try realm.write {
                realm.delete(realmboxing)
            }
        } catch {
            print("error getting xml string: \(error)")
        }
        animateOutConfirmation()
        navigationController?.popViewController(animated: true)
    }
    
    func setupVisualEffectViewConfirmation() {
        navigationController?.view.addSubview(visualEffectView)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        visualEffectView.alpha = 0
    }
    
    func setAlertConfirmation() {
        setupVisualEffectView()
        navigationController?.view.addSubview(alertViewDelete)
        alertViewDelete.center = view.center
        alertViewDelete.set(title: "Внимание", body: "Вы точно хотите удалить все записи черного ящика \(nameDeviceBlackBox!) со своего мобильного устройства?", buttonTitle: "Удалить")
    }
    
    func animateInConfirmation() {
        alertViewDelete.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertViewDelete.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertViewDelete.alpha = 1
            self.alertViewDelete.transform = CGAffineTransform.identity
        }
    }
    func animateOutConfirmation() {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.alertViewDelete.alpha = 0
                        self.alertViewDelete.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                        self.alertViewDelete.removeFromSuperview()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        })
    }
}
