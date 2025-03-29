//
//  TradeCurrencyPairView.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import UIKit

final class TradeCurrencyPairView: UIView {
    private lazy var sellCurrencyView: TradeCurrencyView = {
        let view = TradeCurrencyView(model: model.sellCurrencyModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var buyCurrencyView: TradeCurrencyView = {
        let view = TradeCurrencyView(model: model.buyCurrencyModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightText
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8.0
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

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
    func setupSubviews() {
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
