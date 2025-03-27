//
//  RatesRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import XCTest
@testable import CurrencyConverter

final class RatesRepositoryTests: XCTestCase {
    var apiService: RatesApiServiceMock!

    var sut: RatesRepository!

    override func setUp() {
        super.setUp()

        apiService = RatesApiServiceMock()

        sut = RatesRepository(
            apiService: apiService
        )
    }

    func test_fetchRate_hasExpectedInput() {
        let expectedFromAmount = 100.0
        let expectedFromCurrency = "USD"
        let expectedToCurrency = "EUR"

        sut.fetchRate(
            fromAmount: expectedFromAmount,
            fromCurrency: expectedFromCurrency,
            toCurrency: expectedToCurrency,
            completion: { _ in }
        )

        XCTAssertEqual(apiService.fetchRateFromAmount, expectedFromAmount)
        XCTAssertEqual(apiService.fetchRateFromCurrency, expectedFromCurrency)
        XCTAssertEqual(apiService.fetchRateToCurrency, expectedToCurrency)
    }

    func test_fetchRate_success() {
        let moneyDto = MoneyDto(amount: 100.0, currency: "USD")
        apiService.fetchRateCompletion = .success(moneyDto)

        let expectation = self.expectation(description: "fetchRateCompletion")

        sut.fetchRate(fromAmount: 100, fromCurrency: "", toCurrency: "", completion: { result in
            switch result {
            case let .success(money):
                XCTAssertEqual(money, moneyDto.toDomain())
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    func test_fetchRate_failure() {
        let expectedError = NSError(domain: "fetchRateError", code: 0)
        apiService.fetchRateCompletion = .failure(expectedError)

        let expectation = self.expectation(description: "fetchRateCompletion")

        sut.fetchRate(fromAmount: 100, fromCurrency: "", toCurrency: "", completion: { result in
            switch result {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as NSError, expectedError)
            }
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
}
