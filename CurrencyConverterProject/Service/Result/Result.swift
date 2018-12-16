//
//  Result.swift
//  CurrencyConverterProject
//
//  Created by Margarita Zherikhova on 16/12/2018.
//  Copyright © 2018 Margarita Zherikhova. All rights reserved.
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}
