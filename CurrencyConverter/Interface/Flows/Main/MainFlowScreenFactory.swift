//
//  MainFlowScreenFactory.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit

protocol MainFlowScreenFactoryProtocol {
    func makeCurrencyConverterScreen() -> UIViewController
}

final class MainFlowScreenFactory: MainFlowScreenFactoryProtocol {
    func makeCurrencyConverterScreen() -> UIViewController {
        CurrencyConverterViewController(
            viewModel: CurrencyConverterViewModel(
                currencyAmountInputFormatter: CurrencyAmountInputFormatter(),
                ratesInteractor: RatesInteractor()
            )
        )
    }
}
