//
//  RatesInteractor.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import Foundation

protocol RatesInteractorProtocol {
    func startRateUpdate(
        fireAt: Date,
        fromAmount: Double,
        fromCurrency: String,
        toCurrency: String,
        completion: @escaping (Result<Money, Error>) -> Void
    )
    func stopRateUpdate()
}

final class RatesInteractor: RatesInteractorProtocol {
    private let timerScheduler: TimerSchedulerProtocol
    private let ratesRepository: RatesRepositoryProtocol

    private var timerCancellable: Cancellable?

    init(
        timerScheduler: TimerSchedulerProtocol,
        ratesRepository: RatesRepositoryProtocol
    ) {
        self.timerScheduler = timerScheduler
        self.ratesRepository = ratesRepository
    }

    convenience init() {
        self.init(
            timerScheduler: TimerScheduler(),
            ratesRepository: RatesRepository()
        )
    }

    deinit {
        stopRateUpdate()
    }

    func startRateUpdate(
        fireAt: Date,
        fromAmount: Double,
        fromCurrency: String,
        toCurrency: String,
        completion: @escaping (Result<Money, Error>) -> Void
    ) {
        timerCancellable = timerScheduler.schedule(
            fireAt: fireAt,
            interval: 10,
            repeats: true,
            mode: .common,
            block: { [weak self] timerCancellable in
                self?.ratesRepository.fetchRate(
                    fromAmount: fromAmount,
                    fromCurrency: fromCurrency,
                    toCurrency: toCurrency,
                    completion: completion
                )
            }
        )
    }

    func stopRateUpdate() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
