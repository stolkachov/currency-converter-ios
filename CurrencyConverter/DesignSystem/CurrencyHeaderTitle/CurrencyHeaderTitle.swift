//
//  CurrencyHeaderTitle.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import UIKit

final class CurrencyHeaderTitle: UIControl {
    private let currencyFlagImageView = CurrencyFlagImageView()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .label
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let headerTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let flagHeaderTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted != oldValue {
                updateAppearanceAnimated()
            }
        }
    }

    init(model: Model) {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        updateAppearance()
        update(model: model)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CurrencyHeaderTitle {
    func update(model: Model) {
        currencyFlagImageView.update(model: model.currencyFlagImageViewModel)
        headerLabel.text = model.header
        titleLabel.text = model.title
        model.onTitleDidChange = { [weak self] text in
            self?.titleLabel.text = text
        }

        let action = UIAction(
            handler: { _ in
                model.onTap?()
            }
        )
        addAction(action, for: .touchUpInside)
    }
}

private extension CurrencyHeaderTitle {
    func updateAppearance() {
        if isHighlighted {
            currencyFlagImageView.alpha = 0.33
            titleStackView.alpha = 0.33
        } else {
            currencyFlagImageView.alpha = 1
            titleStackView.alpha = 1.1
        }
    }

    func updateAppearanceAnimated() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .beginFromCurrentState,
            animations: {
                self.updateAppearance()
            },
            completion: nil
        )
    }
}

private extension CurrencyHeaderTitle {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(flagHeaderTitleStackView)
        flagHeaderTitleStackView.addArrangedSubview(currencyFlagImageView)
        flagHeaderTitleStackView.addArrangedSubview(headerTitleStackView)
        headerTitleStackView.addArrangedSubview(headerLabel)
        headerTitleStackView.addArrangedSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleImageView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                currencyFlagImageView.heightAnchor.constraint(equalToConstant: 40),
                currencyFlagImageView.widthAnchor.constraint(equalToConstant: 40),

                flagHeaderTitleStackView.topAnchor.constraint(equalTo: topAnchor),
                flagHeaderTitleStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                flagHeaderTitleStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                flagHeaderTitleStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
}
