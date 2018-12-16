//
//  CurrencyViewModelTests.swift
//  CurrencyConverterProject
//
//  Created by Margarita Zherikhova on 16/12/2018.
//  Copyright © 2018 Margarita Zherikhova. All rights reserved.
//

import XCTest
@testable import CurrencyConverterProject

class CurrencyViewModelTests: XCTestCase {
    
    var viewModel : CurrencyViewModel!
    fileprivate var service : MockCurrencyService!
    
    override func setUp() {
        super.setUp()
        self.service = MockCurrencyService()
        self.viewModel = CurrencyViewModel(service: service)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        super.tearDown()
    }
    
    func testFetchWithNoService() {
        
        // expected to not be able to fetch currencies
        viewModel.fetchCurrencies { result in
            switch result {
            case .success(_) :
                XCTAssert(false, "ViewModel should not be able to fetch without service")
            default:
                break
            }
        }
    }
    
    func testFetchCurrencies() {
        
        // giving a service mocking currencies
        service.converter = Converter(baseCurrency: Currency(rawValue: "GBP")!, date: "01-01-2018", rates: [])
        
        // expected completion to succeed
        viewModel.fetchCurrencies { result in
            switch result {
            case .failure(_) :
                XCTAssert(false, "ViewModel should not be able to fetch without service")
            default:
                break
            }
        }
    }
    
    func testFetchNoCurrencies() {
        
        // giving a service mocking error during fetching currencies
        service.converter = nil
        
        // expected completion to fail
        viewModel.fetchCurrencies { result in
            switch result {
            case .success(_) :
                XCTAssert(false, "ViewModel should not be able to fetch ")
            default:
                break
            }
        }
    }
}

fileprivate class MockCurrencyService : CurrencyServiceProtocol {
    
    var converter : Converter?

    func fetchConverter(_ completion: @escaping ((Result<Converter, ErrorResult>) -> Void)) {

        if let converter = converter {
            completion(Result.success(converter))
        } else {
            completion(Result.failure(ErrorResult.custom(string: "No converter")))
        }
    }
}

