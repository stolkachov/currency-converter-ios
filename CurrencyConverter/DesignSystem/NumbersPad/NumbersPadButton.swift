//
//  NumbersPadButton.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit

final class NumbersPadButton: UIButton {
    private lazy var backgroundView: UIView = {
        let background = UIView()
        background.isUserInteractionEnabled = false
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()

    private let impactFeedbackGenerator: UIImpactFeedbackGenerator

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted != oldValue {
                updateAppearanceAnimated()
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 104, height: 104)
    }

    init(
        model: NumbersPad.Model.Button,
        impactFeedbackGenerator: UIImpactFeedbackGenerator
    ) {
        self.impactFeedbackGenerator = impactFeedbackGenerator
        super.init(frame: .zero)
        setupView()
        updateAppearance()
        update(model: model)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        backgroundView.frame = bounds
        backgroundView.layer.cornerRadius = backgroundView.bounds.height / 2
    }
}

private extension NumbersPadButton {
    func update(model: NumbersPad.Model.Button) {
        setTitle(model.text, for: .normal)

        let action = UIAction(
            handler: { [weak self] _ in
                model.action()
                self?.impactFeedbackGenerator.impactOccurred()
            }
        )
        addAction(action, for: .touchUpInside)
    }
}

private extension NumbersPadButton {
    func updateAppearance() {
        if isHighlighted {
            backgroundView.backgroundColor = .systemGray
            backgroundView.alpha = 0.33
        } else {
            backgroundView.backgroundColor = .systemGray
            backgroundView.alpha = 0.1
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

private extension NumbersPadButton {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(backgroundView)

        titleLabel?.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        setTitleColor(.label, for: .normal)
    }
}
