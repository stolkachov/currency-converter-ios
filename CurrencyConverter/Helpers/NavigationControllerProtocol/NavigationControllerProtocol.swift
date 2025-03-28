//
//  NavigationControllerProtocol.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit

protocol NavigationControllerProtocol {
    func pushViewController(_ viewController: UIViewController, animated: Bool)

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

extension NavigationControllerProtocol {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        present(viewControllerToPresent, animated: flag, completion: nil)
    }

    func dismiss(animated flag: Bool) {
        dismiss(animated: flag, completion: nil)
    }
}

extension UINavigationController: NavigationControllerProtocol {}
