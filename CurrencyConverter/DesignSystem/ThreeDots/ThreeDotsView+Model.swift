//
//  ThreeDotsView+Model.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 30/03/2025.
//

extension ThreeDotsView {
    final class Model {
        var onIsLoadingChange: ((Bool) -> Void)?

        var isLoading: Bool {
            didSet {
                if isLoading != oldValue {
                    onIsLoadingChange?(isLoading)
                }
            }
        }

        init(
            isLoading: Bool = false
        ) {
            self.isLoading = isLoading
        }
    }
}
