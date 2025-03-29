//
//  ClosureMock.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 29/03/2025.
//

final class ClosureMock<T> {
    var value: T?
    var callsCount = 0

    var closure: (T) -> Void {
        { [weak self] value in
            self?.callsCount += 1
            self?.value = value
        }
    }
}
