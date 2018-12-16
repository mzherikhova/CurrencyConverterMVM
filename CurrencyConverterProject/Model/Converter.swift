//
//  Converter.swift
//  CurrencyConverterProject
//
//  Created by Margarita Zherikhova on 16/12/2018.
//  Copyright © 2018 Margarita Zherikhova. All rights reserved.
//

import Foundation

struct Converter {
    let baseCurrency : Currency
    let date : String
    let rates : [CurrencyRate]
}

extension Converter : Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> Result<Converter, ErrorResult> {
        if let base = dictionary["base"] as? String,
            let baseCurrency = Currency(rawValue: base),
            let date = dictionary["date"] as? String,
            let rates = dictionary["rates"] as? [String: Double] {
            
            let finalRates : [CurrencyRate] = rates.compactMap({ CurrencyRate(currency: Currency(rawValue: $0.key)!, rate: $0.value) })
            let conversion = Converter(baseCurrency: baseCurrency, date: date, rates: finalRates)
            
            return Result.success(conversion)
        } else {
            return Result.failure(ErrorResult.parser(string: "Unable to parse conversion rate"))
        }
    }
}
