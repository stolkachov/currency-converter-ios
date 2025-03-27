//
//  RatesRepository.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

protocol RatesRepositoryProtocol {
    func fetchRate(
        fromAmount: Double,
        fromCurrency: String,
        toCurrency: String,
        completion: @escaping (Result<Money, Error>) -> Void
    )
}

final class RatesRepository: RatesRepositoryProtocol {
    private let apiService: RatesApiServiceProtocol

    init(
        apiService: RatesApiServiceProtocol
    ) {
        self.apiService = apiService
    }

    convenience init() {
        self.init(
            apiService: RatesApiService()
        )
    }

    func fetchRate(
        fromAmount: Double,
        fromCurrency: String,
        toCurrency: String,
        completion: @escaping (Result<Money, Error>) -> Void
    ) {
        apiService.fetchRate(
            fromAmount: fromAmount,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            completion: { response in
                let result = response.map({ $0.toDomain() })
                completion(result)
            }
        )
    }
}
