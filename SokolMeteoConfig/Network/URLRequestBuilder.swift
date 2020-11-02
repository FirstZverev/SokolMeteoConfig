//
//  URLRequestBuilder.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 28.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import Alamofire

protocol URLRequestBuilder: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters { get }
    var method: HTTPMethod { get }
}

extension URLRequestBuilder {
    var baseURL: String {
        return "http://185.27.193.112:8004/"
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue("/data?credentials=", forHTTPHeaderField: "")
        return request
    }
}
