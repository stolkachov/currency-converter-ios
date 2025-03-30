//
//  DebouncerMock.swift
//  CurrencyConverterTests
//
//  Created by Semen Tolkachov on 30/03/2025.
//

@testable import CurrencyConverter

final class DebouncerMock: DebouncerProtocol {
    private(set) var debounceCallsCount = 0
    var debounceAction: (() -> Void)!

    func debounce(action: @escaping () -> Void) {
        debounceCallsCount += 1
        debounceAction = action
    }

    private(set) var cancelCallsCount = 0

    func cancel() {
        cancelCallsCount += 1
    }
}
