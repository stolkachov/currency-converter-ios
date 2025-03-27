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

    var sut: MainFlow!

    override func setUp() {
        super.setUp()

        navigationController = NavigationControllerMock()
        screenFactory = MainFlowScreenFactoryMock()

        sut = MainFlow(
            navigationController: navigationController,
            screenFactory: screenFactory
        )
    }

    func test_start_showsCurrencyConverterScreen() {
        let currencyConverterScreen = UIViewController()
        screenFactory.makeCurrencyConverterScreenReturnValue = currencyConverterScreen

        sut.start()

        XCTAssertIdentical(navigationController.pushViewControllerViewController, currencyConverterScreen)
        XCTAssertFalse(navigationController.pushViewControllerAnimated)
    }
}
