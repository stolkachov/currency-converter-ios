//
//  CurrencyFlagImageView+Model.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 29/03/2025.
//

import UIKit

extension CurrencyFlagImageView {
    final class Model {
        let flag: UIImage?

        init(currencyCode: CurrencyCode) {
            self.flag = UIImage(named: currencyCode.rawValue.lowercased())
        }
    }
}
