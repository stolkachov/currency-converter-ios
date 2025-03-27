//
//  MoneyDto.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

struct MoneyDto: Codable {
    let amount: Double
    let currency: String
}

extension MoneyDto {
    func toDomain() -> Money {
        Money(
            amount: amount,
            currency: currency
        )
    }
}
