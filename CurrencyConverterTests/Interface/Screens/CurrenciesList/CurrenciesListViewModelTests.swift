//
//  CurrenciesListViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 29/03/2025.
//

import XCTest
@testable import CurrencyConverter

final class CurrenciesListViewModelTests: XCTestCase {
    let currencies = [CurrencyCode.EUR, .USD]

    var sut: CurrenciesListViewModel!

    func test_selectCurrencyAtIndex_whenIndexIsValid_callsOnCurrencySelectWithCorrectCurrencyCode() {
        let closure = ClosureMock<CurrencyCode>()
        sut = CurrenciesListViewModel(
            currencies: currencies,
            onCurrencySelect: closure.closure
        )

        sut.selectCurrencyAtIndex(index: 1)

        XCTAssertEqual(closure.callsCount, 1)
        XCTAssertEqual(closure.value, .USD)
    }

    func test_selectCurrencyAtIndex_whenIndexIsInvalid_doesNotCallOnCurrencySelect() {
        let closure = ClosureMock<CurrencyCode>()
        sut = CurrenciesListViewModel(
            currencies: currencies,
            onCurrencySelect: closure.closure
        )

        sut.selectCurrencyAtIndex(index: 2)

        XCTAssertEqual(closure.callsCount, 0)
    }
}
