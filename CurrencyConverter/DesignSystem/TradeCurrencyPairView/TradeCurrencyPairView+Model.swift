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

        var isLoading: Bool = false {
            didSet {
                if isLoading != oldValue {
                    isLoading ? startLoadingAnimation() : stopLoadingAnimation()
                }
            }
        }

        init(
            sellCurrencyModel: TradeCurrencyView.Model,
            buyCurrencyModel: TradeCurrencyView.Model
        ) {
            self.sellCurrencyModel = sellCurrencyModel
            self.buyCurrencyModel = buyCurrencyModel
        }
    }
}

private extension TradeCurrencyPairView.Model {
    func startLoadingAnimation() {
        sellCurrencyModel.threeDotsModel.isLoading = true
        buyCurrencyModel.threeDotsModel.isLoading = true
    }

    func stopLoadingAnimation() {
        sellCurrencyModel.threeDotsModel.isLoading = false
        buyCurrencyModel.threeDotsModel.isLoading = false
    }
}
