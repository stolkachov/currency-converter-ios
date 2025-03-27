//
//  MainFlowScreenFactoryMock.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit
@testable import CurrencyConverter

final class MainFlowScreenFactoryMock: MainFlowScreenFactoryProtocol {
    var makeCurrencyConverterScreenReturnValue: UIViewController!

    func makeCurrencyConverterScreen() -> UIViewController {
        makeCurrencyConverterScreenReturnValue
    }
}
