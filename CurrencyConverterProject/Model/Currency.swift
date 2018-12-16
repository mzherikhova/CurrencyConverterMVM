//
//  Currency.swift
//  CurrencyConverterProject
//
//  Created by Margarita Zherikhova on 16/12/2018.
//  Copyright © 2018 Margarita Zherikhova. All rights reserved.
//

import Foundation

enum Currency : String {
    case EUR, AUD, BGN, BRL, CAD, CHF, CNY, CZK, DKK, GBP, HKD, HRK, HUF, IDR, ILS, INR, ISK, JPY, KRW, MXN, MYR, NOK, NZD, PHP, PLN, RON, RUB, SEK, SGD, THB, TRY, USD, ZAR
    
    var title: String { return self.rawValue }
}

enum CurrencyLocale : String {
    case EUR = "fr_FR"
    case GBP = "en_UK"
}

struct CurrencyRate {
    
    let currency : Currency
    let rate : Double
}

