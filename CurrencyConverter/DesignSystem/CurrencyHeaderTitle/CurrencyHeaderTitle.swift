//
//  CurrencyHeaderTitle.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import UIKit

final class CurrencyHeaderTitle: UIControl {
    private lazy var currencyFlagImageView: CurrencyFlagImageView = {
        let imageView = CurrencyFlagImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .lightText
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .white
        label.isUserInteractionEnabled = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var titleImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var headerTitleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var flagHeaderTitleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 16
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        setupSubviews()
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
    func setupSubviews() {
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

                titleImageView.heightAnchor.constraint(equalToConstant: 18),
                titleImageView.widthAnchor.constraint(equalToConstant: 18),

                flagHeaderTitleStackView.topAnchor.constraint(equalTo: topAnchor),
                flagHeaderTitleStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                flagHeaderTitleStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                flagHeaderTitleStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
}
