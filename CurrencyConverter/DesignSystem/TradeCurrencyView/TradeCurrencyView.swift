//
//  TradeCurrencyView.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import UIKit

final class TradeCurrencyView: UIControl {
    private lazy var headerTitleView = CurrencyHeaderTitle(model: model.headerTitleModel)

    private lazy var currencyAmountInputView = CurrencyAmountInputView(model: model.amountInputModel)

    override var isSelected: Bool {
        get { currencyAmountInputView.isSelected }
        set { currencyAmountInputView.isSelected = newValue }
    }

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
}

private extension TradeCurrencyView {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(headerTitleView)
        addSubview(currencyAmountInputView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                headerTitleView.topAnchor.constraint(equalTo: topAnchor),
                headerTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
                headerTitleView.trailingAnchor.constraint(equalTo: currencyAmountInputView.leadingAnchor),
                headerTitleView.bottomAnchor.constraint(equalTo: bottomAnchor),

                currencyAmountInputView.topAnchor.constraint(equalTo: topAnchor),
                currencyAmountInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
                currencyAmountInputView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
        )
    }
}
