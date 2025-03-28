//
//  TradeCurrencyPairView.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import UIKit

final class TradeCurrencyPairView: UIView {
    private lazy var sellCurrencyView: TradeCurrencyView = {
        let currencyView = TradeCurrencyView(model: model.sellCurrencyModel)
        return currencyView
    }()

    private lazy var buyCurrencyView: TradeCurrencyView = {
        let currencyView = TradeCurrencyView(model: model.buyCurrencyModel)
        return currencyView
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .systemGray3
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        return separatorView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let model: Model

    init(model: Model) {
        self.model = model
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func selectSellCurrencyView() {
        sellCurrencyView.isSelected = true
        buyCurrencyView.isSelected = false
    }

    func selectBuyCurrencyView() {
        sellCurrencyView.isSelected = false
        buyCurrencyView.isSelected = true
    }
}

private extension TradeCurrencyPairView {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        stackView.addArrangedSubview(sellCurrencyView)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(buyCurrencyView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                separatorView.heightAnchor.constraint(equalToConstant: 2),

                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
        )
    }
}
