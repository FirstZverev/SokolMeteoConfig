//
//  NetworkingDevices.swift
//  SOKOL
//
//  Created by Володя Зверев on 13.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation

extension ObjectViewCell {
    func networkingPostRequestListDevice(urlString: String) {
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: userDataJSON, options: []) else { return }
//        request.httpBody = httpBody
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(idSession)
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
                guard let result = devices.result else {return}
                devicesList = result
                print(devicesList)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
extension OnlineDataDeviceCell {
    func networkingPostRequestListDevice(urlString: String) {
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: userDataJSON, options: []) else { return }
//        request.httpBody = httpBody
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(idSession)
        request.addValue(idSession, forHTTPHeaderField: "Cookie")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response, let data = data else { return }
            print(response)
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            do {
                let devices = try JSONDecoder().decode(ListDeviceParametrs.self, from: data)
                guard let result = devices.result else { return }
                devicesParametrsList = result
                print(devicesParametrsList)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}

extension GroupController {
    func networkingPostRequestListDevice(urlString: String) {
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: userDataJSON, options: []) else { return }
//        request.httpBody = httpBody
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(idSession)
        request.addValue("application/json", forHTTPHeaderField: "JSESSIONID=\(idSession)")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response, let data = data else { return }
            print(response)
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            do {
                let devices = try JSONDecoder().decode(ListDevices.self, from: data)
                guard let result = devices.result else {return}
                devicesList = result
                print(devicesList)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
