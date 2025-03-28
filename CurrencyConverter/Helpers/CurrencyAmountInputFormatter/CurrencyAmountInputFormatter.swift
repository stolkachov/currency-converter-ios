//
//  CurrencyAmountInputFormatter.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import Foundation

protocol CurrencyAmountInputFormatterProtocol {
    func double(amount: String) -> Double
    func string(amount: String, currencyCode: CurrencyCode) -> String
}

final class CurrencyAmountInputFormatter: CurrencyAmountInputFormatterProtocol {
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = false
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    func double(amount: String) -> Double {
        if amount.isEmpty || amount == "-" {
            return 0
        } else {
            let formattedAmount = amount.replacingOccurrences(of: decimalSeparator, with: ".")
            return Double(formattedAmount) ?? 0
        }
    }

    func string(amount: String, currencyCode: CurrencyCode) -> String {
        let amountDouble = double(amount: amount)

        numberFormatter.currencyCode = currencyCode.rawValue
        numberFormatter.negativePrefix = "-" + numberFormatter.currencySymbol

        if amountDouble == 0 {
            numberFormatter.positivePrefix = numberFormatter.currencySymbol
        } else {
            numberFormatter.positivePrefix = "+" + numberFormatter.currencySymbol
        }

        return numberFormatter.string(from: NSNumber(floatLiteral: amountDouble)) ?? ""
    }
}
