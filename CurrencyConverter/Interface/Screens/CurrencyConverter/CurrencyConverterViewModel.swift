//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import Foundation

final class CurrencyConverterViewModel {
    var onTitleChange: ((_ title: String) -> Void)?
    var onSelectedCurrencyViewChange: ((_ isSellCurrencyViewSelected: Bool) -> Void)?

    private lazy var title: String = makeScreenTitle() {
        didSet {
            if title != oldValue {
                onTitleChange?(title)
            }
        }
    }
    private(set) lazy var tradeCurrencyPairModel = TradeCurrencyPairView.Model(
        sellCurrencyModel: TradeCurrencyView.Model(
            headerTitleModel: CurrencyHeaderTitle.Model(
                header: "Sell",
                currencyCode: sellCurrency
            ),
            amountInputModel: CurrencyAmountInputView.Model(
                text: currencyAmountInputFormatter.string(amount: "0", currencyCode: sellCurrency),
                textColor: .negative
            )
        ),
        buyCurrencyModel: TradeCurrencyView.Model(
            headerTitleModel: CurrencyHeaderTitle.Model(
                header: "Buy",
                currencyCode: buyCurrency
            ),
            amountInputModel: CurrencyAmountInputView.Model(
                text: currencyAmountInputFormatter.string(amount: "0", currencyCode: buyCurrency),
                textColor: .positive
            )
        )
    )
    let numbersPadModel = NumbersPad.Model()

    private var sellCurrency: CurrencyCode = .EUR {
        didSet {
            if sellCurrency != oldValue {
                reset()
                tradeCurrencyPairModel.sellCurrencyModel.headerTitleModel.update(currency: sellCurrency)
            }
        }
    }
    private var buyCurrency: CurrencyCode = .USD {
        didSet {
            if buyCurrency != oldValue {
                title = makeScreenTitle()
                reset()
                tradeCurrencyPairModel.buyCurrencyModel.headerTitleModel.update(currency: buyCurrency)
            }
        }
    }

    private var isSellCurrencyViewSelected: Bool = true {
        didSet {
            if isSellCurrencyViewSelected != oldValue {
                reset()
                onSelectedCurrencyViewChange?(isSellCurrencyViewSelected)
            }
        }
    }

    private let currencyAmountInputFormatter: CurrencyAmountInputFormatterProtocol
    private let debouncer: DebouncerProtocol
    private let ratesInteractor: RatesInteractorProtocol

    private let onSellCurrencyHeaderTitleTap: (
        _ usedCurrencies: [CurrencyCode],
        _ onNewSellCurrencySelect: @escaping (CurrencyCode) -> Void
    ) -> Void
    private let onBuyCurrencyHeaderTitleTap: (
        _ usedCurrencies: [CurrencyCode],
        _ onNewBuyCurrencySelect: @escaping (CurrencyCode) -> Void
    ) -> Void

    init(
        currencyAmountInputFormatter: CurrencyAmountInputFormatterProtocol,
        debouncer: DebouncerProtocol,
        ratesInteractor: RatesInteractorProtocol,
        onSellCurrencyHeaderTitleTap: @escaping (
            _ usedCurrencies: [CurrencyCode],
            _ onNewSellCurrencySelect: @escaping (CurrencyCode) -> Void
        ) -> Void,
        onBuyCurrencyHeaderTitleTap: @escaping (
            _ usedCurrencies: [CurrencyCode],
            _ onNewBuyCurrencySelect: @escaping (CurrencyCode) -> Void
        ) -> Void
    ) {
        self.currencyAmountInputFormatter = currencyAmountInputFormatter
        self.debouncer = debouncer
        self.ratesInteractor = ratesInteractor
        self.onSellCurrencyHeaderTitleTap = onSellCurrencyHeaderTitleTap
        self.onBuyCurrencyHeaderTitleTap = onBuyCurrencyHeaderTitleTap
    }

    func onViewDidLoad() {
        bind()
        onTitleChange?(title)
        onSelectedCurrencyViewChange?(isSellCurrencyViewSelected)
    }
}

private extension CurrencyConverterViewModel {
    func bind() {
        tradeCurrencyPairModel.sellCurrencyModel.headerTitleModel.onTap = { [weak self] in
            guard let self else {
                return
            }
            self.onSellCurrencyHeaderTitleTap(
                [self.sellCurrency, self.buyCurrency],
                { newSellCurrency in
                    self.sellCurrency = newSellCurrency
                }
            )
        }
        tradeCurrencyPairModel.buyCurrencyModel.headerTitleModel.onTap = { [weak self] in
            guard let self else {
                return
            }
            self.onBuyCurrencyHeaderTitleTap(
                [self.sellCurrency, self.buyCurrency],
                { newBuyCurrency in
                    self.buyCurrency = newBuyCurrency
                }
            )
        }
        tradeCurrencyPairModel.sellCurrencyModel.amountInputModel.onTap = { [weak self] in
            self?.isSellCurrencyViewSelected = true
        }
        tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.onTap = { [weak self] in
            self?.isSellCurrencyViewSelected = false
        }
        numbersPadModel.onTextDidChange = { [weak self] text in
            self?.startRateUpdate(amount: text)
        }
    }
}

private extension CurrencyConverterViewModel {
    func startRateUpdate(amount: String) {
        debouncer.cancel()
        ratesInteractor.stopRateUpdate()
        updateConvertFromAmountInput(to: amount)
        debouncer.debounce() { [weak self] in
            guard let self else {
                return
            }

            self.startLoadingAnimation()
            self.ratesInteractor.startRateUpdate(
                fireAt: Date(),
                fromAmount: self.currencyAmountInputFormatter.double(amount: amount),
                fromCurrency: self.isSellCurrencyViewSelected ? self.sellCurrency.rawValue : self.buyCurrency.rawValue,
                toCurrency: self.isSellCurrencyViewSelected ? self.buyCurrency.rawValue : self.sellCurrency.rawValue,
                completion: { result in
                    self.stopLoadingAnimation()
                    switch result {
                    case let .success(money):
                        self.updateConvertToAmountInput(to: money.amount)
                    case let .failure(error):
                        print(error)
                    }
                }
            )
        }
    }
}

private extension CurrencyConverterViewModel {
    func makeScreenTitle() -> String {
        "Buy \(buyCurrency.rawValue)"
    }
}

private extension CurrencyConverterViewModel {
    func reset() {
        debouncer.cancel()
        ratesInteractor.stopRateUpdate()
        resetNumbersPadModel()
        resetSellCurrencyModel()
        resetBuyCurrencyModel()
    }
}

private extension CurrencyConverterViewModel {
    func resetSellCurrencyModel() {
        updateSellAmountInput(to: "0")
    }

    func resetBuyCurrencyModel() {
        updateBuyAmountInput(to: "0")
    }

    func resetNumbersPadModel() {
        numbersPadModel.text = ""
    }
}

private extension CurrencyConverterViewModel {
    func updateConvertFromAmountInput(to amount: String) {
        if isSellCurrencyViewSelected {
            updateSellAmountInput(to: "-\(amount)")
        } else {
            updateBuyAmountInput(to: amount)
        }
    }

    func updateConvertToAmountInput(to amount: String) {
        if isSellCurrencyViewSelected {
            updateBuyAmountInput(to: amount)
        } else {
            updateSellAmountInput(to: "-\(amount)")
        }
    }
}

private extension CurrencyConverterViewModel {
    func updateSellAmountInput(to amount: String) {
        tradeCurrencyPairModel.sellCurrencyModel.amountInputModel.text = currencyAmountInputFormatter.string(
            amount: amount,
            currencyCode: sellCurrency
        )
    }

    func updateBuyAmountInput(to amount: String) {
        tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.text = currencyAmountInputFormatter.string(
            amount: amount,
            currencyCode: buyCurrency
        )
    }
}

private extension CurrencyConverterViewModel {
    func startLoadingAnimation() {
        tradeCurrencyPairModel.isLoading = true
    }

    func stopLoadingAnimation() {
        tradeCurrencyPairModel.isLoading = false
    }
}
