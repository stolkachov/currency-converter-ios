//
//  CurrencyAmountInputView.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import UIKit

final class CurrencyAmountInputView: UIControl {
    enum Constants {
        static let caretWidth: CGFloat = 2
        static let amountLabelFont = UIFont.preferredFont(forTextStyle: .largeTitle)
    }

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.amountLabelFont
        label.textAlignment = .right
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var caretLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.systemGray.cgColor
        return layer
    }()

    override var isSelected: Bool {
        didSet {
            if isSelected != oldValue {
                updateSelectionState()
            }
        }
    }

    init(model: Model) {
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
        subscribeForNotifications()
        updateSelectionState()
        update(model: model)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeNotificationsSubscriptions()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let textSize = ((amountLabel.text ?? "") as NSString).size(withAttributes: [.font: Constants.amountLabelFont])
        caretLayer.frame = CGRect(
            x: amountLabel.bounds.width,
            y: (amountLabel.bounds.height - textSize.height) / 2,
            width: Constants.caretWidth,
            height: textSize.height
        )
    }
}

private extension CurrencyAmountInputView {
    func update(model: Model) {
        amountLabel.text = model.text
        amountLabel.textColor = model.textColor
        model.onTextDidChange = { [weak self] text in
            self?.amountLabel.text = text
        }

        let action = UIAction(
            handler: { _ in
                model.onTap?()
            }
        )
        addAction(action, for: .touchUpInside)
    }
}

private extension CurrencyAmountInputView {
    func updateSelectionState() {
        if isSelected {
            amountLabel.alpha = 1
            stopCaretAnimation()
            startCaretAnimation()
        } else {
            amountLabel.alpha = 0.5
            stopCaretAnimation()
        }
    }
}

private extension CurrencyAmountInputView {
    func startCaretAnimation() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.33
        animation.duration = 0.66
        animation.autoreverses = true
        animation.repeatCount = .infinity
        caretLayer.add(animation, forKey: "blink")
    }

    func stopCaretAnimation() {
        caretLayer.opacity = 0
        caretLayer.removeAnimation(forKey: "blink")
    }
}

private extension CurrencyAmountInputView {
    func setupSubviews() {
        addSubview(amountLabel)
        amountLabel.layer.addSublayer(caretLayer)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                amountLabel.topAnchor.constraint(equalTo: topAnchor),
                amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.caretWidth),
                amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
        )
    }
}

private extension CurrencyAmountInputView {
    func subscribeForNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.updateSelectionState()
            }
        )
    }

    func removeNotificationsSubscriptions() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}
