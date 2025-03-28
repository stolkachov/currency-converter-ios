//
//  TradeCurrencyView+Model.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

extension TradeCurrencyView {
    final class Model {
        let headerTitleModel: CurrencyHeaderTitle.Model
        let amountInputModel: CurrencyAmountInputView.Model

        init(
            headerTitleModel: CurrencyHeaderTitle.Model,
            amountInputModel: CurrencyAmountInputView.Model
        ) {
            self.headerTitleModel = headerTitleModel
            self.amountInputModel = amountInputModel
        }
    }
}
