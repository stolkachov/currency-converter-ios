//
//  NumbersPad+Model.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import Foundation

extension NumbersPad {
    final class Model {
        struct Button {
            let text: String
            let action: () -> Void
        }

        var onTextDidChange: ((String) -> Void)?

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
        Button(
            text: digit,
            action: { [weak self] in
                self?.text.append(digit)
            }
        )
    }

    func makeDecimalSeparatorButton() -> Button {
        Button(
            text: decimalSeparator,
            action: { [weak self] in
                self?.text.append(decimalSeparator)
            }
        )
    }

    func makeDeleteButton() -> Button {
        Button(
            text: "<",
            action: { [weak self] in
                guard let self else {
                    return
                }
                self.text = String(self.text.dropLast())
            }
        )
    }
}
