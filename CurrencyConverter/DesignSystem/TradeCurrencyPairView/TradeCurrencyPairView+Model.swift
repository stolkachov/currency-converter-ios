//
//  TradeCurrencyPairView+Model.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

extension TradeCurrencyPairView {
    final class Model {
        let sellCurrencyModel: TradeCurrencyView.Model
        let buyCurrencyModel: TradeCurrencyView.Model

        init(
            sellCurrencyModel: TradeCurrencyView.Model,
            buyCurrencyModel: TradeCurrencyView.Model
        ) {
            self.sellCurrencyModel = sellCurrencyModel
            self.buyCurrencyModel = buyCurrencyModel
        }
    }
}
