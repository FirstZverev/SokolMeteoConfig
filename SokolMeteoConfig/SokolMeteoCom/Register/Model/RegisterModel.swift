//
//  RegisterModel.swift
//  SOKOL
//
//  Created by Володя Зверев on 13.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

struct RegisterModel: Decodable {
    let id: String?
}
struct RegisterData {
    let email: String
    let password: String
    let name: String
    let surname: String
}

class RegisterViewModel: NSObject {
    static let networkManager = NetworkManager()
    
    static func registration(user: RegisterData ,completion: @escaping (_ text: String) -> () ) {
        let userData: [String: Any] = ["email": user.email, "password": user.password, "fields": ["name": user.name, "surname": user.surname]]
        networkManager.networkingPostRegistation(userDataJSON: userData) { (message, error) in
            if message.localMessage == nil {
                if message.errors == nil {
                    if message.message == nil {
                        completion("OK")
                    } else {
                        completion(message.message!)
                    }
                } else {
                    var result = ""
                    for mes in message.errors! {
                        result += mes + " "
                    }
                    completion(result)
                }
            } else {
                completion(message.localMessage!)
            }
        }
    }
}
