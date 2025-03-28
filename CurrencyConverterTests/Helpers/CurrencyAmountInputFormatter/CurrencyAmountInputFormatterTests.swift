//
//  CurrencyAmountInputFormatterTests.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyAmountInputFormatterTests: XCTestCase {
    let currencyCode: String = {
        let formatter = NumberFormatter()
        formatter.currencyCode = CurrencyCode.EUR.rawValue
        return formatter.currencySymbol!
    }()

    var sut: CurrencyAmountInputFormatter!

    override func setUp() {
        super.setUp()

        sut = CurrencyAmountInputFormatter()
    }

    func test_string_emptyAmount() {
        let result = sut.string(amount: "", currencyCode: .EUR)

        XCTAssertEqual(result, "\(currencyCode)0")
    }

    func test_string_amountOnlyMinusSymbol() {
        let result = sut.string(amount: "-", currencyCode: .EUR)

        XCTAssertEqual(result, "\(currencyCode)0")
    }

    func test_string_amountWithCommaDecimalSeparator() {
        let result = sut.string(amount: "14,55", currencyCode: .EUR)

        XCTAssertEqual(result, "+\(currencyCode)14,55")
    }

    func test_string_negativeAmount() {
        let result = sut.string(amount: "-14,5", currencyCode: .EUR)

        XCTAssertEqual(result, "-\(currencyCode)14,5")
    }
}
