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
    private(set) lazy var sellCurrencyModel = TradeCurrencyView.Model(
        headerTitleModel: CurrencyHeaderTitle.Model(
            header: "Sell",
            title: sellCurrency.rawValue
        ),
        amountInputModel: CurrencyAmountInputView.Model(
            text: currencyAmountInputFormatter.string(amount: "0", currencyCode: sellCurrency),
            textColor: .systemRed
        )
    )
    private(set) lazy var buyCurrencyModel = TradeCurrencyView.Model(
        headerTitleModel: CurrencyHeaderTitle.Model(
            header: "Buy",
            title: buyCurrency.rawValue
        ),
        amountInputModel: CurrencyAmountInputView.Model(
            text: currencyAmountInputFormatter.string(amount: "0", currencyCode: buyCurrency),
            textColor: .systemGreen
        )
    )
    let numbersPadModel = NumbersPad.Model()

    private var sellCurrency: CurrencyCode = .EUR
    private var buyCurrency: CurrencyCode = .USD

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
    private let ratesInteractor: RatesInteractorProtocol

    init(
        currencyAmountInputFormatter: CurrencyAmountInputFormatterProtocol,
        ratesInteractor: RatesInteractorProtocol
    ) {
        self.currencyAmountInputFormatter = currencyAmountInputFormatter
        self.ratesInteractor = ratesInteractor
    }

    func onViewDidLoad() {
        bind()
        onTitleChange?(title)
        onSelectedCurrencyViewChange?(isSellCurrencyViewSelected)
    }
}

private extension CurrencyConverterViewModel {
    func bind() {
        sellCurrencyModel.headerTitleModel.onTap = {
            print("SELL - TITLE")
        }
        sellCurrencyModel.amountInputModel.onTap = { [weak self] in
            self?.isSellCurrencyViewSelected = true
        }
        buyCurrencyModel.headerTitleModel.onTap = {
            print("BUY - TITLE")
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
        ratesInteractor.startRateUpdate(
            fireAt: Date(),
            fromAmount: currencyAmountInputFormatter.double(amount: amount),
            fromCurrency: sellCurrency.rawValue,
            toCurrency: buyCurrency.rawValue,
            completion: { [weak self] result in
                guard let self else {
                    return
                }
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
