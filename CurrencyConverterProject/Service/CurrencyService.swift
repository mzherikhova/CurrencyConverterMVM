//
//  CurrencyService.swift
//  CurrencyConverterProject
//
//  Created by Margarita Zherikhova on 16/12/2018.
//  Copyright © 2018 Margarita Zherikhova. All rights reserved.
//

import Foundation

protocol CurrencyServiceProtocol : class {
    func fetchConverter(_ completion: @escaping ((Result<Converter, ErrorResult>) -> Void))
}

final class CurrencyService : RequestHandler, CurrencyServiceProtocol {
    
    static let shared = CurrencyService()
    
    let endpoint = "https://revolut.duckdns.org/latest?base=EUR"
    var task : URLSessionTask?
    
    func fetchConverter(_ completion: @escaping ((Result<Converter, ErrorResult>) -> Void)) {
        
        // cancel previous request if already in progress
        self.cancelFetchCurrencies()
        
        task = RequestService().loadData(urlString: endpoint, completion: self.networkResult(completion: completion))
    }
    
    func cancelFetchCurrencies() {
        
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}
