//
//  File.swift
//  CurrencyConverterProject
//
//  Created by Margarita Zherikhova on 16/12/2018.
//  Copyright © 2018 Margarita Zherikhova. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}
