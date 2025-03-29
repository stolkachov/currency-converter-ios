//
//  CurrenciesListViewModel.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 29/03/2025.
//

final class CurrenciesListViewModel {
    let displayModels: [CurrenciesListCurrencyTableViewCell.Model]

    private let currencies: [CurrencyCode]
    private let onCurrencySelect: (CurrencyCode) -> Void

    init(
        currencies: [CurrencyCode],
        onCurrencySelect: @escaping (CurrencyCode) -> Void
    ) {
        self.currencies = currencies
        self.onCurrencySelect = onCurrencySelect

        self.displayModels = currencies.map({ CurrenciesListCurrencyTableViewCell.Model(currencyCode: $0) })
    }

    func selectCurrencyAtIndex(index: Int) {
        guard let currency = currencies[safe: index] else {
            return
        }
        onCurrencySelect(currency)
    }
}
