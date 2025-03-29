//
//  NumbersPad+Model.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import Foundation
import UIKit

extension NumbersPad {
    final class Model {
        enum Button {
            case text(text: String, action: () -> Void)
            case image(image: UIImage?, action: () -> Void)

            var action: () -> Void {
                switch self {
                case let .text(_, action):
                    return action
                case let .image(_, action):
                    return action
                }
            }
        }

        var onTextDidChange: ((String) -> Void)?

        var shouldAppendDecimalSeparator: (String) -> Bool = { _ in true }
        var shouldAppendDigit: (String) -> Bool = { _ in true }

        var text: String = "" {
            didSet {
                if text != oldValue {
                    onTextDidChange?(text)
                }
            }
        }

        private(set) var buttons: [[Button]] = []

        init() {
            self.buttons = makeButtons()
        }
    }
}

private extension NumbersPad.Model {
    func makeButtons() -> [[Button]] {
        let row1 = ["1", "2", "3"].map({ makeDigitButton(digit: $0) })
        let row2 = ["4", "5", "6"].map({ makeDigitButton(digit: $0) })
        let row3 = ["7", "8", "9"].map({ makeDigitButton(digit: $0) })

        let decimalSeparatorButton = makeDecimalSeparatorButton()
        let zeroDigitButton = makeDigitButton(digit: "0")
        let deleteButton = makeDeleteButton()

        let row4: [Button] = [decimalSeparatorButton, zeroDigitButton, deleteButton]

        return [row1, row2, row3, row4]
    }

    func makeDigitButton(digit: String) -> Button {
        Button.text(
            text: digit,
            action: { [weak self] in
                guard let self else {
                    return
                }
                guard self.shouldAppendDigit(self.text) else {
                    return
                }
                self.text.append(digit)
            }
        )
    }

    func makeDecimalSeparatorButton() -> Button {
        Button.text(
            text: decimalSeparator,
            action: { [weak self] in
                guard let self else {
                    return
                }
                guard self.shouldAppendDecimalSeparator(self.text) else {
                    return
                }
                self.text.append(decimalSeparator)
            }
        )
    }

    func makeDeleteButton() -> Button {
        Button.image(
            image: UIImage(systemName: "delete.backward", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1)),
            action: { [weak self] in
                guard let self else {
                    return
                }
                self.text = String(self.text.dropLast())
            }
        )
    }
}
