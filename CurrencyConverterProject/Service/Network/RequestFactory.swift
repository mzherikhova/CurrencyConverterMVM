//
//  RequestFactory.swift
//  CurrencyConverterProject
//
//  Created by Margarita Zherikhova on 16/12/2018.
//  Copyright © 2018 Margarita Zherikhova. All rights reserved.
//

import Foundation

final class RequestFactory {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }
    
    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
