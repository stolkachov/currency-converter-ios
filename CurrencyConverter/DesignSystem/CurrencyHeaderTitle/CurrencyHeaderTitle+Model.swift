//
//  CurrencyHeaderTitle+Model.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

extension CurrencyHeaderTitle {
    final class Model {
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
            title: String
        ) {
            self.header = header
            self.title = title
        }
    }
}
