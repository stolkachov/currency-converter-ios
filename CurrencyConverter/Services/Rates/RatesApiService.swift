//
//  RatesApiService.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import Alamofire

protocol RatesApiServiceProtocol {
    func fetchRate(
        fromAmount: Double,
        fromCurrency: String,
        toCurrency: String,
        completion: @escaping (Result<MoneyDto, Error>) -> Void
    )
}

final class RatesApiService: RatesApiServiceProtocol {
    func fetchRate(
        fromAmount: Double,
        fromCurrency: String,
        toCurrency: String,
        completion: @escaping (Result<MoneyDto, Error>) -> Void
    ) {
        AF
            .request("http://api.evp.lt/currency/commercial/exchange/\(fromAmount)-\(fromCurrency)/\(toCurrency)/latest")
            .responseDecodable(of: MoneyDto.self) { response in
                let result = response.result.mapError({ $0 as Error })
                completion(result)
            }
    }
}
