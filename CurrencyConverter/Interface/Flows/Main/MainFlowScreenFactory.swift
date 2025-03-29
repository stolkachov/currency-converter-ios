//
//  MainFlowScreenFactory.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit

protocol MainFlowScreenFactoryProtocol {
    func makeCurrencyConverterScreen(
        onSellCurrencyHeaderTitleTap: @escaping (
            _ usedCurrencies: [CurrencyCode],
            _ onNewSellCurrencySelect: @escaping (CurrencyCode) -> Void
        ) -> Void,
        onBuyCurrencyHeaderTitleTap: @escaping (
            _ usedCurrencies: [CurrencyCode],
            _ onNewBuyCurrencySelect: @escaping (CurrencyCode) -> Void
        ) -> Void
    ) -> UIViewController

    func makeCurrenciesListScreen(
        currencies: [CurrencyCode],
        onCurrencySelect: @escaping (CurrencyCode) -> Void
    ) -> UIViewController
}

final class MainFlowScreenFactory: MainFlowScreenFactoryProtocol {
    func makeCurrencyConverterScreen(
        onSellCurrencyHeaderTitleTap: @escaping (
            _ usedCurrencies: [CurrencyCode],
            _ onNewSellCurrencySelect: @escaping (CurrencyCode) -> Void
        ) -> Void,
        onBuyCurrencyHeaderTitleTap: @escaping (
            _ usedCurrencies: [CurrencyCode],
            _ onNewBuyCurrencySelect: @escaping (CurrencyCode) -> Void
        ) -> Void
    ) -> UIViewController {
        CurrencyConverterViewController(
            viewModel: CurrencyConverterViewModel(
                currencyAmountInputFormatter: CurrencyAmountInputFormatter(),
                ratesInteractor: RatesInteractor(),
                onSellCurrencyHeaderTitleTap: onSellCurrencyHeaderTitleTap,
                onBuyCurrencyHeaderTitleTap: onBuyCurrencyHeaderTitleTap
            )
        )
    }

    func makeCurrenciesListScreen(
        currencies: [CurrencyCode],
        onCurrencySelect: @escaping (CurrencyCode) -> Void
    ) -> UIViewController {
        UINavigationController(
            rootViewController: CurrenciesListViewController(
                viewModel: CurrenciesListViewModel(
                    currencies: currencies,
                    onCurrencySelect: onCurrencySelect
                )
            )
        )
    }
}
