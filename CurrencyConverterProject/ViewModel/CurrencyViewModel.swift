//
//  CurrencyViewModel.swift
//  CurrencyConverterProject
//
//  Created by Margarita Zherikhova on 16/12/2018.
//  Copyright © 2018 Margarita Zherikhova. All rights reserved.
//

import Foundation

struct RateData {
    let currency : Currency
    var amount : Double
}

private let defaultCurrency = Currency.EUR

class CurrencyViewModel {
    
    lazy private(set) var data: DynamicValue<[RateData]> = DynamicValue([])
    
    private weak var service: CurrencyServiceProtocol?
    private var timer: DispatchSourceTimer?
    
    private var sourceData: [CurrencyRate] = [] {
        didSet { data.value = recalculateData(sourceData, data.value, baseCurrency, primaryRate) }
    }

    //Data
    var baseCurrency: Currency = defaultCurrency
    var primaryRate = RateData(currency: defaultCurrency, amount: 1)  {
        didSet {
            updatePrimaryRate(oldValue, primaryRate)
            data.value = recalculateData(sourceData, data.value, baseCurrency, primaryRate)
        }
    }
    //
    
    init(service: CurrencyServiceProtocol = CurrencyService.shared) {
        self.service = service
    }
    
    func fetchCurrencies(_ completion: ((Result<Bool, ErrorResult>) -> Void)? = nil) {
        
        guard let service = service else {
            completion?(Result.failure(ErrorResult.custom(string: "Missing service")))
            return
        }
        
        service.fetchConverter { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let converter) :

                    self.sourceData = converter.rates
                    completion?(Result.success(true))
                
                case .failure(let error) :
                    print("Parser error \(error)")
                    completion?(Result.failure(error))
                }
            }
        }
    }
    
    func startAutoUpdate() {
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: .seconds(5))
        timer?.setEventHandler(handler: { [weak self] in
            self?.fetchCurrencies()
        })
        timer?.resume()
    }
    
    func stopAutoUpdate() {
        timer?.cancel()
        timer = nil
    }
    
    private func updatePrimaryRate(_ from: RateData, _ to: RateData) {        
        var dataValue = data.value
        dataValue.removeAll(where: { $0.currency == to.currency })
        dataValue.insert(to, at: 0)
        data.value = dataValue
    }
    
    private func recalculateData(_ source: [CurrencyRate],
                                 _ rateData: [RateData],
                                 _ baseCurrency: Currency,
                                 _ primaryRate: RateData) -> [RateData] {
        
        let defaultRate = CurrencyRate(currency: baseCurrency, rate: 1)
        var sourceDic: [Currency : CurrencyRate] = [baseCurrency : defaultRate]
        for element in source {
            sourceDic[element.currency] = element
        }
        
        let primaryCurrency = sourceDic[primaryRate.currency]!
        let ratio = 1/primaryCurrency.rate
        
        var inputData: [RateData] = rateData
        if inputData.isEmpty {
            inputData.append(RateData(currency: defaultCurrency, amount: 1))
            inputData.append(contentsOf: source.map({ RateData(currency: $0.currency, amount: $0.rate) }))
        }
        
        let output = inputData.map({ RateData(currency: $0.currency, amount: (sourceDic[$0.currency]!.rate * ratio * primaryRate.amount)) })
        return output
    }
}
