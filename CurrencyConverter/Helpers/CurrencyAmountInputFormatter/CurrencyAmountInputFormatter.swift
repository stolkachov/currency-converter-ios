//
//  CurrencyAmountInputFormatter.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import Foundation

protocol CurrencyAmountInputFormatterProtocol {
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

    func string(amount: String, currencyCode: CurrencyCode) -> String {
        let formattedAmount: Double = if amount.isEmpty || amount == "-" {
            0
        } else {
            Double(amount.replacingOccurrences(of: Locale.current.decimalSeparator ?? ",", with: ".")) ?? 0
        }

        numberFormatter.currencyCode = currencyCode.rawValue
        numberFormatter.negativePrefix = "-" + numberFormatter.currencySymbol

        if formattedAmount == 0 {
            numberFormatter.positivePrefix = numberFormatter.currencySymbol
        } else {
            numberFormatter.positivePrefix = "+" + numberFormatter.currencySymbol
        }

        return numberFormatter.string(from: NSNumber(floatLiteral: formattedAmount)) ?? ""
    }
}
