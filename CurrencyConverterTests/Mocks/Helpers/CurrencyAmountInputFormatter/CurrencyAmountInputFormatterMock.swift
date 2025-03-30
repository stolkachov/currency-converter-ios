//
//  CurrencyAmountInputFormatterMock.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 30/03/2025.
//

@testable import CurrencyConverter

final class CurrencyAmountInputFormatterMock: CurrencyAmountInputFormatterProtocol {
    private(set) var doubleAmount: String!
    var doubleReturnValue: Double!

    func double(amount: String) -> Double {
        doubleAmount = amount
        return doubleReturnValue
    }

    private(set) var stringAmount: [String] = []
    private(set) var stringCurrencyCode: [CurrencyCode] = []
    var stringReturnValue: String!

    func string(amount: String, currencyCode: CurrencyCode) -> String {
        stringAmount.append(amount)
        stringCurrencyCode.append(currencyCode)
        return stringReturnValue
    }
}
