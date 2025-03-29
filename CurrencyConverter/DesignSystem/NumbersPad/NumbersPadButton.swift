//
//  NumbersPadButton.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit

final class NumbersPadButton: UIButton {
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        setupSubviews()
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
            backgroundView.backgroundColor = .white
            backgroundView.alpha = 0.33
        } else {
            backgroundView.backgroundColor = .white
            backgroundView.alpha = 0.05
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
    func setupSubviews() {
        addSubview(backgroundView)

        titleLabel?.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        setTitleColor(.white, for: .normal)
    }
}
