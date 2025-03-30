//
//  Debouncer.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 29/03/2025.
//

import Foundation

protocol DebouncerProtocol {
    func debounce(action: @escaping () -> Void)
    func cancel()
}

final class Debouncer: DebouncerProtocol {
    private var currentWorkItem: DispatchWorkItem? = nil

    private let delay: DispatchTimeInterval
    private let queue: DispatchQueue

    init(
        delay: DispatchTimeInterval = .seconds(1),
        queue: DispatchQueue = .main
    ) {
        self.delay = delay
        self.queue = queue
    }

    func debounce(action: @escaping () -> Void) {
        currentWorkItem?.cancel()
        currentWorkItem = DispatchWorkItem { [weak self] in
            action()
            self?.currentWorkItem = nil
        }
        queue.asyncAfter(deadline: .now() + delay, execute: self.currentWorkItem!)
    }

    func cancel() {
        currentWorkItem?.cancel()
        currentWorkItem = nil
    }
}
