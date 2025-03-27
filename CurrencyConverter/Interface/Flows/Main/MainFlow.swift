//
//  MainFlow.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit

final class MainFlow {
    private let navigationController: NavigationControllerProtocol
    private let screenFactory: MainFlowScreenFactoryProtocol

    init(
        navigationController: NavigationControllerProtocol,
        screenFactory: MainFlowScreenFactoryProtocol
    ) {
        self.navigationController = navigationController
        self.screenFactory = screenFactory
    }

    convenience init(
        navigationController: NavigationControllerProtocol
    ) {
        self.init(
            navigationController: navigationController,
            screenFactory: MainFlowScreenFactory()
        )
    }

    func start() {
        showCurrencyConverterScreen()
    }
}

private extension MainFlow {
    func showCurrencyConverterScreen() {
        let screen = screenFactory.makeCurrencyConverterScreen()
        navigationController.pushViewController(screen, animated: false)
    }
}
