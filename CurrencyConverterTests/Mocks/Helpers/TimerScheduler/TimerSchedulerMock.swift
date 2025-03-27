//
//  TimerSchedulerMock.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import Foundation
@testable import CurrencyConverter

final class TimerSchedulerMock: TimerSchedulerProtocol {
    private(set) var scheduleFireAt: Date!
    private(set) var scheduleInterval: TimeInterval!
    private(set) var scheduleRepeats: Bool!
    private(set) var scheduleMode: RunLoop.Mode!
    var scheduleBlock: (Cancellable)?
    var scheduleReturnValue: Cancellable!

    func schedule(
        fireAt: Date,
        interval: TimeInterval,
        repeats: Bool,
        mode: RunLoop.Mode,
        block: @escaping (Cancellable) -> Void
    ) -> Cancellable {
        scheduleFireAt = fireAt
        scheduleInterval = interval
        scheduleRepeats = repeats
        scheduleMode = mode
        if let scheduleBlock {
            block(scheduleBlock)
        }
        return scheduleReturnValue
    }
}
