//
//  NavigationControllerMock.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit
@testable import CurrencyConverter

final class NavigationControllerMock: NavigationControllerProtocol {
    private(set) var pushViewControllerViewController: UIViewController!
    private(set) var pushViewControllerAnimated: Bool!

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerViewController = viewController
        pushViewControllerAnimated = animated
    }
}
