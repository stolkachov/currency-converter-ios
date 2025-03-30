//
//  TradeCurrencyView.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import UIKit

final class TradeCurrencyView: UIControl {
    private lazy var headerTitleView: CurrencyHeaderTitle = {
        let view = CurrencyHeaderTitle(model: model.headerTitleModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var currencyAmountInputView: CurrencyAmountInputView = {
        let view = CurrencyAmountInputView(model: model.amountInputModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var threeDotsView: ThreeDotsView = {
        let view = ThreeDotsView(model: model.threeDotsModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override var isSelected: Bool {
        get { currencyAmountInputView.isSelected }
        set { currencyAmountInputView.isSelected = newValue }
    }

    private let model: Model

    init(model: Model) {
        self.model = model
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TradeCurrencyView {
    func setupSubviews() {
        addSubview(headerTitleView)
        addSubview(currencyAmountInputView)
        addSubview(threeDotsView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                headerTitleView.topAnchor.constraint(equalTo: topAnchor),
                headerTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
                headerTitleView.trailingAnchor.constraint(equalTo: currencyAmountInputView.leadingAnchor, constant: -8),
                headerTitleView.bottomAnchor.constraint(equalTo: bottomAnchor),

                currencyAmountInputView.topAnchor.constraint(equalTo: topAnchor),
                currencyAmountInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
                currencyAmountInputView.bottomAnchor.constraint(equalTo: threeDotsView.topAnchor, constant: -4),

                threeDotsView.trailingAnchor.constraint(equalTo: trailingAnchor),
                threeDotsView.bottomAnchor.constraint(equalTo: bottomAnchor),
                threeDotsView.heightAnchor.constraint(equalToConstant: 6),
                threeDotsView.widthAnchor.constraint(equalToConstant: 26),
            ]
        )
    }
}
