//
//  CurrencyAmountInputView+Model.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import UIKit

extension CurrencyAmountInputView {
    final class Model {
        var text: String {
            didSet {
                if text != oldValue {
                    onTextDidChange?(text)
                }
            }
        }
        let textColor: UIColor

        var onTextDidChange: ((String) -> Void)?
        var onTap: (() -> Void)?

        init(
            text: String,
            textColor: UIColor
        ) {
            self.text = text
            self.textColor = textColor
        }
    }
}
