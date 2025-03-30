//
//  RatesInteractorMock.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 30/03/2025.
//

import Foundation
@testable import CurrencyConverter

final class RatesInteractorMock: RatesInteractorProtocol {
    private(set) var startRateUpdateFireAt: Date!
    private(set) var startRateUpdateFromAmount: Double!
    private(set) var startRateUpdateFromCurrency: String!
    private(set) var startRateUpdateToCurrency: String!
    var startRateUpdateCompletion: ((Result<Money, Error>) -> Void)!

    func startRateUpdate(
        fireAt: Date,
        fromAmount: Double,
        fromCurrency: String,
        toCurrency: String,
        completion: @escaping (Result<Money, Error>) -> Void
    ) {
        startRateUpdateFireAt = fireAt
        startRateUpdateFromAmount = fromAmount
        startRateUpdateFromCurrency = fromCurrency
        startRateUpdateToCurrency = toCurrency
        startRateUpdateCompletion = completion
    }

    private(set) var stopRateUpdateCallsCount = 0

    func stopRateUpdate() {
        stopRateUpdateCallsCount += 1
    }
}
