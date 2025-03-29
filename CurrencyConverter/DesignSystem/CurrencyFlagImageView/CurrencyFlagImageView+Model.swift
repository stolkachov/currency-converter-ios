//
//  CurrencyFlagImageView+Model.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 29/03/2025.
//

import UIKit

extension CurrencyFlagImageView {
    final class Model {
        var onFlagDidChange: ((UIImage?) -> Void)?

        var flag: UIImage? {
            didSet {
                if flag != oldValue {
                    onFlagDidChange?(flag)
                }
            }
        }

        init(currencyCode: CurrencyCode) {
            self.flag = UIImage(named: currencyCode.rawValue.lowercased())
        }

        func update(currencyCode: CurrencyCode) {
            self.flag = UIImage(named: currencyCode.rawValue.lowercased())
        }
    }
}
