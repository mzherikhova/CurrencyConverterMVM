//
//  CurrencyServiceTests.swift
//  CurrencyConverterProject
//
//  Created by Margarita Zherikhova on 16/12/2018.
//  Copyright © 2018 Margarita Zherikhova. All rights reserved.
//

import XCTest
@testable import CurrencyConverterProject

class CurrencyServiceTests: XCTestCase {
    
    func testCancelRequest() {
        
        // giving a "previous" session
        CurrencyService.shared.fetchConverter { (_) in
            // ignore call
        }
        
        // Expected to task nil after cancel
        CurrencyService.shared.cancelFetchCurrencies()
        XCTAssertNil(CurrencyService.shared.task, "Expected task nil")
    }
}
