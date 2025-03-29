//
//  CurrenciesListCurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 29/03/2025.
//

import UIKit

final class CurrenciesListCurrencyTableViewCell: UITableViewCell {
    private let currencyFlagImageView = CurrencyFlagImageView()

    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    private let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()

    private let codeNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private let flagCodeNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        currencyFlagImageView.image = nil
        currencyCodeLabel.text = nil
        currencyNameLabel.text = nil
    }

    func update(model: Model) {
        currencyFlagImageView.update(model: model.currencyFlagImageViewModel)
        currencyCodeLabel.text = model.currencyCode
        currencyNameLabel.text = model.currencyName
    }
}

private extension CurrenciesListCurrencyTableViewCell {
    func setupSubviews() {
        contentView.addSubview(flagCodeNameStackView)
        flagCodeNameStackView.addArrangedSubview(currencyFlagImageView)
        flagCodeNameStackView.addArrangedSubview(codeNameStackView)
        codeNameStackView.addArrangedSubview(currencyCodeLabel)
        codeNameStackView.addArrangedSubview(currencyNameLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                flagCodeNameStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 16),
                flagCodeNameStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                flagCodeNameStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
                flagCodeNameStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            ]
        )
    }
}
