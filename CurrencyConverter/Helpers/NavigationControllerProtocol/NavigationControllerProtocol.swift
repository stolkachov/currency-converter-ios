//
//  NavigationControllerProtocol.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit

protocol NavigationControllerProtocol {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

extension UINavigationController: NavigationControllerProtocol {}
