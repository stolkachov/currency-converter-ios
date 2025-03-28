//
//  CurrencyHeaderTitle.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import UIKit

final class CurrencyHeaderTitle: UIControl {
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .label
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var titleIcon: UIImageView = {
        let image = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var headerTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
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
            titleStackView.alpha = 0.33
        } else {
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

        addSubview(headerTitleStackView)
        headerTitleStackView.addArrangedSubview(headerLabel)
        headerTitleStackView.addArrangedSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleIcon)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                headerTitleStackView.topAnchor.constraint(equalTo: topAnchor),
                headerTitleStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                headerTitleStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                headerTitleStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
}
