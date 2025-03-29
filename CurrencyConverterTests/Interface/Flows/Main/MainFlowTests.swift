//
//  MainFlowTests.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import XCTest
@testable import CurrencyConverter

final class MainFlowTests: XCTestCase {
    var navigationController: NavigationControllerMock!
    var screenFactory: MainFlowScreenFactoryMock!

    let currencyConverterScreen = UIViewController()
    let currencyListScreen = UIViewController()

    var sut: MainFlow!

    override func setUp() {
        super.setUp()

        navigationController = NavigationControllerMock()
        screenFactory = MainFlowScreenFactoryMock()

        screenFactory.makeCurrencyConverterScreenReturnValue = currencyConverterScreen
        screenFactory.makeCurrenciesListScreenReturnValue = currencyListScreen

        sut = MainFlow(
            navigationController: navigationController,
            screenFactory: screenFactory
        )
    }

    func test_start_showsCurrencyConverterScreen() {
        sut.start()

        XCTAssertIdentical(navigationController.pushViewControllerViewController, currencyConverterScreen)
        XCTAssertFalse(navigationController.pushViewControllerAnimated)
    }

    func test_onSellCurrencyHeaderTitleTap_showsCurrencyListScreen() {
        sut.start()
        screenFactory.makeCurrencyConverterScreenOnSellCurrencyHeaderTitleTap([.USD], { _ in })

        XCTAssertFalse(screenFactory.makeCurrenciesListScreenCurrencies.contains(.USD))
        XCTAssertIdentical(navigationController.presentViewControllerViewController, currencyListScreen)
        XCTAssertTrue(navigationController.presentViewControllerAnimated)
    }

    func test_onNewSellCurrencySelect_dismissesCurrencyListScreenAndCallsExpectedClosure() {
        let closure = ClosureMock<CurrencyCode>()

        sut.start()
        screenFactory.makeCurrencyConverterScreenOnSellCurrencyHeaderTitleTap([.USD], closure.closure)
        screenFactory.makeCurrenciesListScreenOnCurrencySelect(.JPY)

        XCTAssertEqual(closure.callsCount, 1)
        XCTAssertEqual(closure.value, .JPY)
        XCTAssertEqual(navigationController.dismissCallsCount, 1)
        XCTAssertTrue(navigationController.dismissAnimated)
    }

    func test_onBuyCurrencyHeaderTitleTap_showsCurrencyListScreen() {
        sut.start()

        screenFactory.makeCurrencyConverterScreenOnBuyCurrencyHeaderTitleTap([.EUR], { _ in })

        XCTAssertFalse(screenFactory.makeCurrenciesListScreenCurrencies.contains(.EUR))
        XCTAssertIdentical(navigationController.presentViewControllerViewController, currencyListScreen)
        XCTAssertTrue(navigationController.presentViewControllerAnimated)
    }

    func test_onNewBuyCurrencySelect_dismissesCurrencyListScreenAndCallsExpectedClosure() {
        let closure = ClosureMock<CurrencyCode>()

        sut.start()
        screenFactory.makeCurrencyConverterScreenOnBuyCurrencyHeaderTitleTap([.EUR], closure.closure)
        screenFactory.makeCurrenciesListScreenOnCurrencySelect(.KRW)

        XCTAssertEqual(closure.callsCount, 1)
        XCTAssertEqual(closure.value, .KRW)
        XCTAssertEqual(navigationController.dismissCallsCount, 1)
        XCTAssertTrue(navigationController.dismissAnimated)
    }
}
