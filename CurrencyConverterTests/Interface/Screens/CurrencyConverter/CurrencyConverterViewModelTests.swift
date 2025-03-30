//
//  CurrencyConverterViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 30/03/2025.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyConverterViewModelTests: XCTestCase {
    var currencyAmountInputFormatter: CurrencyAmountInputFormatterMock!
    var debouncer: DebouncerMock!
    var ratesInteractor: RatesInteractorMock!
    var onSellCurrencyHeaderTitleTap: ClosureMock<([CurrencyCode], (CurrencyCode) -> Void)>!
    var onBuyCurrencyHeaderTitleTap: ClosureMock<([CurrencyCode], (CurrencyCode) -> Void)>!

    var sut: CurrencyConverterViewModel!

    override func setUp() {
        super.setUp()
        currencyAmountInputFormatter = CurrencyAmountInputFormatterMock()
        debouncer = DebouncerMock()
        ratesInteractor = RatesInteractorMock()
        onSellCurrencyHeaderTitleTap = ClosureMock()
        onBuyCurrencyHeaderTitleTap = ClosureMock()

        currencyAmountInputFormatter.doubleReturnValue = -9999
        currencyAmountInputFormatter.stringReturnValue = "invalid return value"

        sut = CurrencyConverterViewModel(
            currencyAmountInputFormatter: currencyAmountInputFormatter,
            debouncer: debouncer,
            ratesInteractor: ratesInteractor,
            onSellCurrencyHeaderTitleTap: { currencyCode, onCurrencySelect in
                self.onSellCurrencyHeaderTitleTap.closure((currencyCode, onCurrencySelect))
            },
            onBuyCurrencyHeaderTitleTap: { currencyCode, onCurrencySelect in
                self.onBuyCurrencyHeaderTitleTap.closure((currencyCode, onCurrencySelect))
            }
        )
    }

    func test_onViewDidLoad_updatesScreenTitle() {
        let onTitleChange = ClosureMock<(String)>()
        sut.onTitleChange = onTitleChange.closure

        sut.onViewDidLoad()

        XCTAssertEqual(onTitleChange.callsCount, 1)
        XCTAssertEqual(onTitleChange.value, "Buy USD")
    }

    func test_onViewDidLoad_updatesSelectedCurrencyView() {
        let onSelectedCurrencyViewChange = ClosureMock<(Bool)>()
        sut.onSelectedCurrencyViewChange = onSelectedCurrencyViewChange.closure

        sut.onViewDidLoad()

        XCTAssertEqual(onSelectedCurrencyViewChange.callsCount, 1)
        XCTAssertEqual(onSelectedCurrencyViewChange.value, true)
    }

    func test_onSellCurrencyHeaderTitleTap_callsExpectedClosure() {
        sut.onViewDidLoad()

        sut.tradeCurrencyPairModel.sellCurrencyModel.headerTitleModel.onTap?()

        XCTAssertEqual(onSellCurrencyHeaderTitleTap.callsCount, 1)
        XCTAssertEqual(onSellCurrencyHeaderTitleTap.value?.0, [.EUR, .USD])
    }

    func test_onSellCurrencyChange_updatesSellCurrency() {
        let expectedAmountString = "expected-amount-string"
        currencyAmountInputFormatter.stringReturnValue = expectedAmountString

        sut.onViewDidLoad()
        sut.tradeCurrencyPairModel.sellCurrencyModel.headerTitleModel.onTap?()
        onSellCurrencyHeaderTitleTap.value?.1(.JPY)

        XCTAssertEqual(debouncer.cancelCallsCount, 1)
        XCTAssertEqual(ratesInteractor.stopRateUpdateCallsCount, 1)
        XCTAssertEqual(sut.numbersPadModel.text, "")
        XCTAssertEqual(currencyAmountInputFormatter.stringAmount[2], "0")
        XCTAssertEqual(currencyAmountInputFormatter.stringCurrencyCode[2], .JPY)
        XCTAssertEqual(sut.tradeCurrencyPairModel.sellCurrencyModel.amountInputModel.text, expectedAmountString)
        XCTAssertEqual(currencyAmountInputFormatter.stringAmount[3], "0")
        XCTAssertEqual(currencyAmountInputFormatter.stringCurrencyCode[3], .USD)
        XCTAssertEqual(sut.tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.text, expectedAmountString)
        XCTAssertEqual(sut.tradeCurrencyPairModel.sellCurrencyModel.headerTitleModel.title, CurrencyCode.JPY.rawValue)
    }

    func test_onBuyCurrencyChange_updatesBuyCurrency() {
        let expectedAmountString = "expected-amount-string"
        currencyAmountInputFormatter.stringReturnValue = expectedAmountString
        let onTitleChange = ClosureMock<(String)>()
        sut.onTitleChange = onTitleChange.closure

        sut.onViewDidLoad()
        sut.tradeCurrencyPairModel.buyCurrencyModel.headerTitleModel.onTap?()
        onBuyCurrencyHeaderTitleTap.value?.1(.JPY)

        XCTAssertEqual(onTitleChange.callsCount, 2)
        XCTAssertEqual(onTitleChange.value, "Buy JPY")
        XCTAssertEqual(debouncer.cancelCallsCount, 1)
        XCTAssertEqual(ratesInteractor.stopRateUpdateCallsCount, 1)
        XCTAssertEqual(sut.numbersPadModel.text, "")
        XCTAssertEqual(currencyAmountInputFormatter.stringAmount[2], "0")
        XCTAssertEqual(currencyAmountInputFormatter.stringCurrencyCode[2], .EUR)
        XCTAssertEqual(sut.tradeCurrencyPairModel.sellCurrencyModel.amountInputModel.text, expectedAmountString)
        XCTAssertEqual(currencyAmountInputFormatter.stringAmount[3], "0")
        XCTAssertEqual(currencyAmountInputFormatter.stringCurrencyCode[3], .JPY)
        XCTAssertEqual(sut.tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.text, expectedAmountString)
        XCTAssertEqual(sut.tradeCurrencyPairModel.buyCurrencyModel.headerTitleModel.title, CurrencyCode.JPY.rawValue)
    }

    func test_onSellCurrencyViewSelect_whenSellCurrencyViewIsAlreadySelected_callsExpectedClosure() {
        let onSelectedCurrencyViewChange = ClosureMock<(Bool)>()
        sut.onSelectedCurrencyViewChange = onSelectedCurrencyViewChange.closure

        sut.onViewDidLoad()
        sut.tradeCurrencyPairModel.sellCurrencyModel.amountInputModel.onTap?()

        XCTAssertEqual(onSelectedCurrencyViewChange.callsCount, 1)
    }

    func test_onSellCurrencyViewSelect_whenBuyCurrencyViewIsSelected_callsExpectedClosure() {
        let onSelectedCurrencyViewChange = ClosureMock<(Bool)>()
        sut.onSelectedCurrencyViewChange = onSelectedCurrencyViewChange.closure

        sut.onViewDidLoad()
        sut.tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.onTap?()
        sut.tradeCurrencyPairModel.sellCurrencyModel.amountInputModel.onTap?()

        XCTAssertEqual(onSelectedCurrencyViewChange.callsCount, 3)
        XCTAssertEqual(onSelectedCurrencyViewChange.value, true)
    }

    func test_onBuyCurrencyViewSelect_callsExpectedClosure() {
        let onSelectedCurrencyViewChange = ClosureMock<(Bool)>()
        sut.onSelectedCurrencyViewChange = onSelectedCurrencyViewChange.closure

        sut.onViewDidLoad()
        sut.tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.onTap?()

        XCTAssertEqual(onSelectedCurrencyViewChange.callsCount, 2)
        XCTAssertEqual(onSelectedCurrencyViewChange.value, false)
    }

    func test_onSellTextDidChange_startsRateUpdate() {
        let expectedText = "expected-text"
        let expectedAmountString = "expected-amount-string"
        let expectedAmountDouble = 123.45
        currencyAmountInputFormatter.doubleReturnValue = expectedAmountDouble

        sut.onViewDidLoad()
        currencyAmountInputFormatter.stringReturnValue = expectedAmountString
        sut.numbersPadModel.onTextDidChange?(expectedText)
        debouncer.debounceAction()

        XCTAssertEqual(debouncer.cancelCallsCount, 1)
        XCTAssertEqual(ratesInteractor.stopRateUpdateCallsCount, 1)
        XCTAssertEqual(currencyAmountInputFormatter.stringAmount[2], "-\(expectedText)")
        XCTAssertEqual(currencyAmountInputFormatter.stringCurrencyCode[2], .EUR)
        XCTAssertEqual(sut.tradeCurrencyPairModel.sellCurrencyModel.amountInputModel.text, expectedAmountString)
        XCTAssertNotEqual(sut.tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.text, expectedAmountString)
        XCTAssertEqual(debouncer.debounceCallsCount, 1)
        XCTAssertEqual(sut.tradeCurrencyPairModel.isLoading, true)
        XCTAssertEqual(currencyAmountInputFormatter.doubleAmount, expectedText)
        XCTAssertEqual(ratesInteractor.startRateUpdateFromAmount, expectedAmountDouble)
        XCTAssertEqual(ratesInteractor.startRateUpdateFromCurrency, CurrencyCode.EUR.rawValue)
        XCTAssertEqual(ratesInteractor.startRateUpdateToCurrency, CurrencyCode.USD.rawValue)
    }

    func test_onSellTextDidChange_startsRateUpdate_onSuccess_updatesUi() {
        let expectedMoney = Money(amount: "expected-amount")
        let expectedAmountString = "expected-amount-string"

        sut.onViewDidLoad()
        sut.numbersPadModel.onTextDidChange?("123")
        debouncer.debounceAction()
        currencyAmountInputFormatter.stringReturnValue = expectedAmountString
        ratesInteractor.startRateUpdateCompletion?(.success(expectedMoney))

        XCTAssertEqual(sut.tradeCurrencyPairModel.isLoading, false)
        XCTAssertEqual(currencyAmountInputFormatter.stringAmount[3], expectedMoney.amount)
        XCTAssertEqual(currencyAmountInputFormatter.stringCurrencyCode[3], .USD)
        XCTAssertNotEqual(sut.tradeCurrencyPairModel.sellCurrencyModel.amountInputModel.text, expectedAmountString)
        XCTAssertEqual(sut.tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.text, expectedAmountString)
    }

    func test_onBuyTextDidChange_startsRateUpdate() {
        let expectedText = "expected-text"
        let expectedAmountString = "expected-amount-string"
        let expectedAmountDouble = 123.45

        sut.onViewDidLoad()
        sut.tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.onTap?()
        currencyAmountInputFormatter.doubleReturnValue = expectedAmountDouble
        currencyAmountInputFormatter.stringReturnValue = expectedAmountString
        sut.numbersPadModel.onTextDidChange?(expectedText)
        debouncer.debounceAction()

        XCTAssertEqual(debouncer.cancelCallsCount, 2)
        XCTAssertEqual(ratesInteractor.stopRateUpdateCallsCount, 2)
        XCTAssertNotEqual(sut.tradeCurrencyPairModel.sellCurrencyModel.amountInputModel.text, expectedAmountString)
        XCTAssertEqual(currencyAmountInputFormatter.stringAmount[4], expectedText)
        XCTAssertEqual(currencyAmountInputFormatter.stringCurrencyCode[4], .USD)
        XCTAssertEqual(sut.tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.text, expectedAmountString)
        XCTAssertEqual(debouncer.debounceCallsCount, 1)
        XCTAssertEqual(sut.tradeCurrencyPairModel.isLoading, true)
        XCTAssertEqual(currencyAmountInputFormatter.doubleAmount, expectedText)
        XCTAssertEqual(ratesInteractor.startRateUpdateFromAmount, expectedAmountDouble)
        XCTAssertEqual(ratesInteractor.startRateUpdateFromCurrency, CurrencyCode.USD.rawValue)
        XCTAssertEqual(ratesInteractor.startRateUpdateToCurrency, CurrencyCode.EUR.rawValue)
    }

    func test_onBuyTextDidChange_startsRateUpdate_onSuccess_updatesUi() {
        let expectedText = "expected-text"
        let expectedMoney = Money(amount: "expected-amount")
        let expectedAmountString = "expected-amount-string"

        sut.onViewDidLoad()
        sut.tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.onTap?()
        sut.numbersPadModel.onTextDidChange?(expectedText)
        debouncer.debounceAction()
        currencyAmountInputFormatter.stringReturnValue = expectedAmountString
        ratesInteractor.startRateUpdateCompletion?(.success(expectedMoney))

        XCTAssertEqual(sut.tradeCurrencyPairModel.isLoading, false)
        XCTAssertEqual(currencyAmountInputFormatter.stringAmount[5], "-\(expectedMoney.amount)")
        XCTAssertEqual(currencyAmountInputFormatter.stringCurrencyCode[5], .EUR)
        XCTAssertEqual(sut.tradeCurrencyPairModel.sellCurrencyModel.amountInputModel.text, expectedAmountString)
        XCTAssertNotEqual(sut.tradeCurrencyPairModel.buyCurrencyModel.amountInputModel.text, expectedAmountString)
    }
}
