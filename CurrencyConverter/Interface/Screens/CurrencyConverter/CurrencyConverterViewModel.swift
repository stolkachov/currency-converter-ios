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
                onSelectedCurrencyViewChange?(isSellCurrencyViewSelected)
            }
        }
    }

    private let currencyAmountInputFormatter: CurrencyAmountInputFormatterProtocol

    init(
        currencyAmountInputFormatter: CurrencyAmountInputFormatterProtocol
    ) {
        self.currencyAmountInputFormatter = currencyAmountInputFormatter
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
            guard let self else {
                return
            }
            if self.isSellCurrencyViewSelected {
                self.sellCurrencyModel.amountInputModel.text = currencyAmountInputFormatter.string(amount: "-\(text)", currencyCode: sellCurrency)
            } else {
                self.buyCurrencyModel.amountInputModel.text = currencyAmountInputFormatter.string(amount: text, currencyCode: buyCurrency)
            }
        }
    }
}

private extension CurrencyConverterViewModel {
    func makeTitle() -> String {
        "Buy \(buyCurrency.rawValue)"
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
