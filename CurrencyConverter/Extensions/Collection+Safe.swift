//
//  Collection+Safe.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 29/03/2025.
//

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
