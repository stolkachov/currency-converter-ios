//
//  TimerScheduler.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import Foundation

protocol TimerSchedulerProtocol {
    func schedule(
        fireAt: Date,
        interval: TimeInterval,
        repeats: Bool,
        mode: RunLoop.Mode,
        block: @escaping (Cancellable) -> Void
    ) -> Cancellable
}

final class TimerScheduler: TimerSchedulerProtocol {
    func schedule(
        fireAt: Date,
        interval: TimeInterval,
        repeats: Bool,
        mode: RunLoop.Mode,
        block: @escaping (Cancellable) -> Void
    ) -> Cancellable {
        let timer = Timer(fire: fireAt, interval: interval, repeats: repeats, block: { timer in
            block(
                AnyCancellable(cancel: { timer.invalidate() })
            )
        })
        RunLoop.current.add(timer, forMode: mode)
        return AnyCancellable(cancel: { timer.invalidate() })
    }
}
