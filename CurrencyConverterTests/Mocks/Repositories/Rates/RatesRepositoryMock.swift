//
//  RatesRepositoryMock.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 27/03/2025.
//

@testable import CurrencyConverter

final class RatesRepositoryMock: RatesRepositoryProtocol {
    private(set) var fetchRateFromAmount: Double!
    private(set) var fetchRateFromCurrency: String!
    private(set) var fetchRateToCurrency: String!
    var fetchRateCompletion: (Result<Money, Error>)?

    func fetchRate(
        fromAmount: Double,
        fromCurrency: String,
        toCurrency: String,
        completion: @escaping (Result<Money, Error>) -> Void
    ) {
        fetchRateFromAmount = fromAmount
        fetchRateFromCurrency = fromCurrency
        fetchRateToCurrency = toCurrency
        if let fetchRateCompletion {
            completion(fetchRateCompletion)
        }
    }
}
