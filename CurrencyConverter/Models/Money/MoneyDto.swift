//
//  MoneyDto.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

struct MoneyDto: Codable {
    let amount: String
}

extension MoneyDto {
    func toDomain() -> Money {
        Money(
            amount: amount
        )
    }
}
