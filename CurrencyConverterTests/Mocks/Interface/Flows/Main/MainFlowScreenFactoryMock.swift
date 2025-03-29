//
//  MainFlowScreenFactoryMock.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit
@testable import CurrencyConverter

final class MainFlowScreenFactoryMock: MainFlowScreenFactoryProtocol {
    var makeCurrencyConverterScreenOnSellCurrencyHeaderTitleTap: (([CurrencyCode], @escaping (CurrencyCode) -> Void) -> Void)!
    var makeCurrencyConverterScreenOnBuyCurrencyHeaderTitleTap: (([CurrencyCode], @escaping (CurrencyCode) -> Void) -> Void)!
    var makeCurrencyConverterScreenReturnValue: UIViewController!

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
        makeCurrencyConverterScreenOnSellCurrencyHeaderTitleTap = onSellCurrencyHeaderTitleTap
        makeCurrencyConverterScreenOnBuyCurrencyHeaderTitleTap = onBuyCurrencyHeaderTitleTap
        return makeCurrencyConverterScreenReturnValue
    }

    var makeCurrenciesListScreenCurrencies: [CurrencyCode]!
    var makeCurrenciesListScreenOnCurrencySelect: ((CurrencyCode) -> Void)!
    var makeCurrenciesListScreenReturnValue: UIViewController!

    func makeCurrenciesListScreen(
        currencies: [CurrencyCode],
        onCurrencySelect: @escaping (CurrencyCode) -> Void
    ) -> UIViewController {
        makeCurrenciesListScreenCurrencies = currencies
        makeCurrenciesListScreenOnCurrencySelect = onCurrencySelect
        return makeCurrenciesListScreenReturnValue
    }
}
