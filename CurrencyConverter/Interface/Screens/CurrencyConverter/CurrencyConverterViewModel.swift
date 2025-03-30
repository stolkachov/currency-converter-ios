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

    private lazy var title: String = makeTitle() {
        didSet {
            if title != oldValue {
                onTitleChange?(title)
            }
        }
    }
    private(set) lazy var tradeCurrencyPairModel = TradeCurrencyPairView.Model(
        sellCurrencyModel: sellCurrencyModel,
        buyCurrencyModel: buyCurrencyModel
    )
    private(set) lazy var sellCurrencyModel = TradeCurrencyView.Model(
        headerTitleModel: CurrencyHeaderTitle.Model(
            header: "Sell",
            currencyCode: sellCurrency
        ),
        amountInputModel: CurrencyAmountInputView.Model(
            text: currencyAmountInputFormatter.string(amount: "0", currencyCode: sellCurrency),
            textColor: .negative
        )
    )
    private(set) lazy var buyCurrencyModel = TradeCurrencyView.Model(
        headerTitleModel: CurrencyHeaderTitle.Model(
            header: "Buy",
            currencyCode: buyCurrency
        ),
        amountInputModel: CurrencyAmountInputView.Model(
            text: currencyAmountInputFormatter.string(amount: "0", currencyCode: buyCurrency),
            textColor: .positive
        )
    )
    let numbersPadModel = NumbersPad.Model()

    private var sellCurrency: CurrencyCode = .EUR {
        didSet {
            if sellCurrency != oldValue {
                reset()
                ratesInteractor.stopRateUpdate()
                sellCurrencyModel.headerTitleModel.currencyFlagImageViewModel.update(currencyCode: sellCurrency)
                sellCurrencyModel.headerTitleModel.title = sellCurrency.rawValue
            }
        }
    }
    private var buyCurrency: CurrencyCode = .USD {
        didSet {
            if buyCurrency != oldValue {
                title = makeTitle()
                reset()
                ratesInteractor.stopRateUpdate()
                buyCurrencyModel.headerTitleModel.currencyFlagImageViewModel.update(currencyCode: buyCurrency)
                buyCurrencyModel.headerTitleModel.title = buyCurrency.rawValue
            }
        }
    }

    private var isSellCurrencyViewSelected: Bool = true {
        didSet {
            if isSellCurrencyViewSelected != oldValue {
                reset()
                ratesInteractor.stopRateUpdate()
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
        sellCurrencyModel.headerTitleModel.onTap = { [weak self] in
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
        sellCurrencyModel.amountInputModel.onTap = { [weak self] in
            self?.isSellCurrencyViewSelected = true
        }
        buyCurrencyModel.headerTitleModel.onTap = { [weak self] in
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
        buyCurrencyModel.amountInputModel.onTap = { [weak self] in
            self?.isSellCurrencyViewSelected = false
        }
        numbersPadModel.onTextDidChange = { [weak self] text in
            self?.startRateUpdate(amount: text)
        }
    }
}

private extension CurrencyConverterViewModel {
    func makeTitle() -> String {
        "Buy \(buyCurrency.rawValue)"
    }
}

private extension CurrencyConverterViewModel {
    func startRateUpdate(amount: String) {
        if isSellCurrencyViewSelected {
            sellCurrencyModel.amountInputModel.text = currencyAmountInputFormatter.string(amount: "-\(amount)", currencyCode: sellCurrency)
        } else {
            buyCurrencyModel.amountInputModel.text = currencyAmountInputFormatter.string(amount: amount, currencyCode: buyCurrency)
        }
        ratesInteractor.stopRateUpdate()
        debouncer.cancel()
        debouncer.debounce() { [weak self] in
            guard let self else {
                return
            }

            self.sellCurrencyModel.threeDotsModel.isLoading = true
            self.buyCurrencyModel.threeDotsModel.isLoading = true
            self.ratesInteractor.startRateUpdate(
                fireAt: Date(),
                fromAmount: self.currencyAmountInputFormatter.double(amount: amount),
                fromCurrency: self.sellCurrency.rawValue,
                toCurrency: self.buyCurrency.rawValue,
                completion: { [weak self] result in
                    guard let self else {
                        return
                    }
                    self.sellCurrencyModel.threeDotsModel.isLoading = false
                    self.buyCurrencyModel.threeDotsModel.isLoading = false
                    switch result {
                    case let .success(money):
                        if self.isSellCurrencyViewSelected {
                            self.buyCurrencyModel.amountInputModel.text = self.currencyAmountInputFormatter.string(amount: money.amount, currencyCode: self.buyCurrency)
                        } else {
                            self.sellCurrencyModel.amountInputModel.text = self.currencyAmountInputFormatter.string(amount: "-\(money.amount)", currencyCode: self.sellCurrency)
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
            )
        }

    }
}

private extension CurrencyConverterViewModel {
    func reset() {
        resetNumbersPadModel()
        resetSellCurrencyModel()
        resetBuyCurrencyModel()
    }

    func resetSellCurrencyModel() {
        sellCurrencyModel.amountInputModel.text = currencyAmountInputFormatter.string(amount: "0", currencyCode: sellCurrency)
    }

    func resetBuyCurrencyModel() {
        buyCurrencyModel.amountInputModel.text = currencyAmountInputFormatter.string(amount: "0", currencyCode: buyCurrency)
    }

    func resetNumbersPadModel() {
        numbersPadModel.text = ""
    }
}
