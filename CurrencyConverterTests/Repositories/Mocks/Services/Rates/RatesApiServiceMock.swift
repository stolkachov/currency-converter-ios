//
//  RatesApiServiceMock.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 27/03/2025.
//

@testable import CurrencyConverter

final class RatesApiServiceMock: RatesApiServiceProtocol {
    private(set) var fetchRateCalled = false
    private(set) var fetchRateFromAmount: Double!
    private(set) var fetchRateFromCurrency: String!
    private(set) var fetchRateToCurrency: String!
    var fetchRateCompletion: (Result<MoneyDto, Error>)?

    func fetchRate(
        fromAmount: Double,
        fromCurrency: String,
        toCurrency: String,
        completion: @escaping (Result<MoneyDto, Error>) -> Void
    ) {
        fetchRateCalled = true
        fetchRateFromAmount = fromAmount
        fetchRateFromCurrency = fromCurrency
        fetchRateToCurrency = toCurrency
        if let fetchRateCompletion {
            completion(fetchRateCompletion)
        }
    }
}
