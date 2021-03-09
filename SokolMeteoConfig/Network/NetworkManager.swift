//
//  NetworkManager.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 28.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class NetworkManager {
    let urlBase = "185.27.193.112:8004/"

    func networkingRequest(urlString: String, completion: @escaping (_ photoFormat: [DataDevices]?,_ error: String?) -> () ) {
        
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(idSession, forHTTPHeaderField: "Cookie")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let devices = try JSONDecoder().decode(ListDevices.self, from: responseData)
                        guard let result = devices.result else {return}
                        completion(result, nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }.resume()
    }
    
    func networkingPostRequestListDevice(urlString: String, completion: @escaping (_ photoFormat: [ResultOnline]?,_ error: String?) -> () ) {
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        print(idSession)
        request.addValue(idSession, forHTTPHeaderField: "Cookie")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let devices = try JSONDecoder().decode(OnlineNetwork.self, from: responseData)
                        guard let result = devices.result else { return }
                        completion(result, nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }.resume()
    }
    
    func networkingPostRequestAddDevice(userDataJSON: [String: Any], completion: @escaping (_ photoFormat: String?,_ error: String?) -> () ) {
        guard let url = URL(string: "http://185.27.193.112:8004/device/") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userDataJSON, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(idSession, forHTTPHeaderField: "Cookie")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
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
                if let errors = jsonSecond.errors {
                    guard let errorFirst = errors.first else { return }
                    DispatchQueue.main.async {
                        let window = UIApplication.shared.keyWindow?.rootViewController
                        window?.showToast(message: errorFirst, seconds: 1.0)
                    }
                }
                if let error = jsonSecond.localMessage {
                    completion(nil,error)
                }
                guard let JSESSIONID = jsonSecond.result else {return}
                if jsonSecond.state == "OK" {
                    completion(JSESSIONID,nil)
                } else {

                }
                completion(JSESSIONID, nil)
            } catch {
                print(error)
                completion(nil, NetworkResponse.unableToDecode.rawValue)
            }
        }.resume()
    }
    
    func networkingPostRequestListDevice(completion: @escaping (_ data: [DataDevices]?,_ error: String?) -> () ) {
        
        guard let url = URL(string: "http://185.27.193.112:8004/device/all?start=0&count=1000&sortDir=desc") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: userDataJSON, options: []) else { return }
//        request.httpBody = httpBody
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(idSession)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(idSession, forHTTPHeaderField: "Cookie")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response, let data = data else { return }
            print(response)
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            do {
                let devices = try JSONDecoder().decode(ListDevices.self, from: data)
                print("devices: \(devices)")
                if (devices.message != nil) {
                    completion(nil, devices.message)
                }
                guard let result = devices.result else {return}
                devicesList = result
                print(devicesList)
                completion(result, nil)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    func networkingPostRequestForecast(selectId: String, startDateString: String, endDateString: String, completion: @escaping (_ data: [ResultForecast]?,_ error: String?) -> () ) {
        
        guard let url = URL(string: "http://185.27.193.112:8004/forecast/all?deviceId=\(selectId)&startDate=\(startDateString)&endDate=\(endDateString)") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(idSession, forHTTPHeaderField: "Cookie")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response, let data = data else { return }
            print(response)
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            do {
                let devices = try JSONDecoder().decode(Forecast.self, from: data)
                print("devices: \(devices)")
                guard let result = devices.result else {return}
                completion(result, nil)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

