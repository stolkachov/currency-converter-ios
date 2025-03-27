//
//  RatesInteractorTests.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import XCTest
@testable import CurrencyConverter

final class RatesInteractorTests: XCTestCase {
    var timerScheduler: TimerSchedulerMock!
    var ratesRepository: RatesRepositoryMock!

    var sut: RatesInteractor!

    override func setUp() {
        super.setUp()

        timerScheduler = TimerSchedulerMock()
        ratesRepository = RatesRepositoryMock()

        sut = RatesInteractor(
            timerScheduler: timerScheduler,
            ratesRepository: ratesRepository
        )
    }

    func test_startRateUpdate_schedulesTimerWithExpectedValues() {
        let expectedFireAt = Date(timeIntervalSinceNow: 1_000_000)

        timerScheduler.scheduleReturnValue = AnyCancellable(cancel: {})

        sut.startRateUpdate(
            fireAt: expectedFireAt,
            fromAmount: 1,
            fromCurrency: "",
            toCurrency: "",
            completion: { _ in }
        )

        XCTAssertEqual(timerScheduler.scheduleFireAt, expectedFireAt)
        XCTAssertEqual(timerScheduler.scheduleInterval, 10)
        XCTAssertTrue(timerScheduler.scheduleRepeats)
        XCTAssertEqual(timerScheduler.scheduleMode, .common)
    }

    func test_startRateUpdate_fetchesRatesWithExpectedValues() {
        let expectedFromAmount = 100.0
        let expectedFromCurrency = "USD"
        let expectedToCurrency = "EUR"

        let timer = AnyCancellable(cancel: {})
        timerScheduler.scheduleBlock = timer
        timerScheduler.scheduleReturnValue = timer

        sut.startRateUpdate(
            fireAt: Date(),
            fromAmount: expectedFromAmount,
            fromCurrency: expectedFromCurrency,
            toCurrency: expectedToCurrency,
            completion: { _ in }
        )

        XCTAssertEqual(ratesRepository.fetchRateFromAmount, expectedFromAmount)
        XCTAssertEqual(ratesRepository.fetchRateFromCurrency, expectedFromCurrency)
        XCTAssertEqual(ratesRepository.fetchRateToCurrency, expectedToCurrency)
    }

    func test_startRateUpdate_fetchRate_completion_success() {
        let expectedMoney = Money(amount: "100", currency: "USD")
        let timer = AnyCancellable(cancel: {})
        timerScheduler.scheduleBlock = timer
        timerScheduler.scheduleReturnValue = timer
        ratesRepository.fetchRateCompletion = .success(expectedMoney)

        let expectation = self.expectation(description: "fetchRateCompletion")

        sut.startRateUpdate(
            fireAt: Date(),
            fromAmount: 1,
            fromCurrency: "",
            toCurrency: "",
            completion: { result in
                switch result {
                case let .success(money):
                    XCTAssertEqual(money, expectedMoney)
                case .failure:
                    XCTFail()
                }
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: 1)
    }

    func test_startRateUpdate_fetchRate_completion_failure() {
        let expectedError = NSError(domain: "fetchRateError", code: 0)
        let timer = AnyCancellable(cancel: {})
        timerScheduler.scheduleBlock = timer
        timerScheduler.scheduleReturnValue = timer
        ratesRepository.fetchRateCompletion = .failure(expectedError)

        let expectation = self.expectation(description: "fetchRateCompletion")

        sut.startRateUpdate(
            fireAt: Date(),
            fromAmount: 1,
            fromCurrency: "",
            toCurrency: "",
            completion: { result in
                switch result {
                case .success:
                    XCTFail()
                case let .failure(error):
                    XCTAssertEqual(error as NSError, expectedError)
                }
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: 1)
    }
}
