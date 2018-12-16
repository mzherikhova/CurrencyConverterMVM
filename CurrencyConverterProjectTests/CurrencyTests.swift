//
//  CurrencyTests.swift
//  CurrencyConverterProject
//
//  Created by Margarita Zherikhova on 16/12/2018.
//  Copyright © 2018 Margarita Zherikhova. All rights reserved.
//

import XCTest
@testable import CurrencyConverterProject

class CurrencyTests: XCTestCase {
    
    func testParseEmptyCurrency() {
        
        // giving empty data
        let data = Data()
        
        // giving completion after parsing 
        // expected valid converter with valid data
        let completion : ((Result<Converter, ErrorResult>) -> Void) = { result in
            switch result {
            case .success(_):    
                XCTAssert(false, "Expected failure when no data")
            default:
                break
            }
        }
        
        ParserHelper.parse(data: data, completion: completion)
    }
    
    func testParseCurrency() {
        
        // giving a sample json file
        guard let data = FileManager.readJson(forResource: "sample") else {
            XCTAssert(false, "Can't get data from sample.json")
            return
        }
        
        // giving completion after parsing 
        // expected valid converter with valid data
        let completion : ((Result<Converter, ErrorResult>) -> Void) = { result in
            switch result {
            case .failure(_):
                XCTAssert(false, "Expected valid converter")
            case .success(let converter):
                
                XCTAssertEqual(converter.baseCurrency, Currency(rawValue: "GBP"), "Expected GBP base")
                XCTAssertEqual(converter.date, "2018-02-01", "Expected 2018-02-01 date")
                XCTAssertEqual(converter.rates.count, 32, "Expected 32 rates")
            }
        }
        
        ParserHelper.parse(data: data, completion: completion)
    }
    
    func testWrongKeyCurrency() {
        
        // giving a wrong dictionary
        let dictionary = ["test" : 123 as AnyObject]
        
        // expected to return error of converter
        let result = Converter.parseObject(dictionary: dictionary)
        
        switch result {
        case .success(_):
            XCTAssert(false, "Expected failure when wrong data")
        default:
            return
        }
    }
}

extension FileManager {
    
    static func readJson(forResource fileName: String ) -> Data? {
    
        let bundle = Bundle(for: CurrencyTests.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        }
        
        return nil
    }
}
