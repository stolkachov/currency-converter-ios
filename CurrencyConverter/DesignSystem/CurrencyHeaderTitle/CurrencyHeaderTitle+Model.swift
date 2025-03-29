//
//  CurrencyHeaderTitle+Model.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import UIKit

extension CurrencyHeaderTitle {
    final class Model {
        let currencyFlagImageViewModel: CurrencyFlagImageView.Model
        let header: String
        var title: String {
            didSet {
                if title != oldValue {
                    onTitleDidChange?(title)
                }
            }
        }

        var onTitleDidChange: ((String) -> Void)?
        var onTap: (() -> Void)?

        init(
            header: String,
            currencyCode: CurrencyCode
        ) {
            self.currencyFlagImageViewModel = CurrencyFlagImageView.Model(currencyCode: currencyCode)
            self.header = header
            self.title = currencyCode.rawValue
        }
    }
}
