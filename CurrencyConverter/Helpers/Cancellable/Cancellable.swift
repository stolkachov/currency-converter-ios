//
//  Cancellable.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

protocol Cancellable: AnyObject {
    func cancel()
}

final class AnyCancellable: Cancellable {
    private let _cancel: () -> Void

    init(
        cancel: @escaping () -> Void
    ) {
        self._cancel = cancel
    }

    func cancel() {
        _cancel()
    }
}
