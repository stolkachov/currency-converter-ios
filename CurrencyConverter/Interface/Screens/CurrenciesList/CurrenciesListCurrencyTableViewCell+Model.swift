//
//  CurrenciesListCurrencyTableViewCell+Model.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 29/03/2025.
//

import Foundation

extension CurrenciesListCurrencyTableViewCell {
    final class Model {
        let currencyFlagImageViewModel: CurrencyFlagImageView.Model
        let currencyCode: String
        let currencyName: String?

        init(currencyCode: CurrencyCode) {
            self.currencyFlagImageViewModel = CurrencyFlagImageView.Model(currencyCode: currencyCode)
            self.currencyCode = currencyCode.rawValue
            self.currencyName = (Locale.current as NSLocale).displayName(forKey: .currencyCode, value: currencyCode.rawValue)
        }
    }
}
