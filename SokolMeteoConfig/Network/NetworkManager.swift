//
//  NetworkManager.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 28.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Foundation
//
//class NetworkFeedManager {
//    
//    let urlMain = "http://185.27.193.112:8004/"
//    var onComplition: ((Network) -> Void)?
//    
//    func fetchCurrentFeed() {
//        let urlString = urlMain + "/data?credentials=c2VyZWdhMzE5NzVAZ21haWwuY29tOjEyMzQ1Njc4&page=1&count=10"
//        guard let url = URL(string: urlString) else {return}
//        let session = URLSession(configuration: .default)
//        let task = session.dataTask(with: url) { data, response, error in
//            if let data = data {
//                let dataString = String(data: data, encoding: .utf8)
//                print(dataString!)
////                print(data)
//                if let currentFeed = self.parseJSON(withData: data) {
//                    print("stateNext: \(currentFeed.state)")
//                    self.onComplition?(currentFeed)
//                }
//            }
//        }
//        task.resume()
//    }
//    
//    func parseJSON(withData data: Data) -> Network? {
//        let decoder = JSONDecoder()
//        do {
//           let currentFeedData = try decoder.decode(NetworkData.self, from: data)
//            guard let currentFeed = Network(currentFeedData: currentFeedData) else {
//                return nil
//            }
//            return currentFeed
//        } catch let errpr as NSError {
//            print(errpr.localizedDescription)
//        }
//        return nil
//    }
//}
