//
//  ThreeDotsView.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 29/03/2025.
//

import UIKit

final class ThreeDotsView: UIView {
    private lazy var dots: [UIView] = {
        (0...2).map { _ in
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
    }()

    private lazy var dotsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var isAnimating = false {
        didSet {
            isAnimating ? startDotsAnimation() : stopDotsAnimation()
        }
    }

    private let model: Model

    init(model: Model) {
        self.model = model
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
        subscribeForNotifications()
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
        dots.forEach { dot in
            dot.layer.cornerRadius = bounds.height / 2
        }
    }
}

private extension ThreeDotsView {
    func update(model: Model) {
        isAnimating = model.isLoading
        model.onIsLoadingChange = { [weak self] isLoading in
            self?.isAnimating = isLoading
        }
    }
}

private extension ThreeDotsView {
    func startDotsAnimation() {
        stopDotsAnimation()
        isHidden = false
        dots.enumerated().forEach { index, dot in
            startDotAnimation(dot: dot, index: index)
        }
    }

    func startDotAnimation(dot: UIView, index: Int) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0, 1.25, 0.5, 1.0]
        animation.keyTimes = [0, 0.33, 0.66, 1.0]
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.beginTime = CACurrentMediaTime() + Double(index) * 0.1
        dot.layer.add(animation, forKey: "scale")
    }

    func stopDotsAnimation() {
        isHidden = true
        dots.forEach { dot in dot.layer.removeAnimation(forKey: "scale") }
    }
}

private extension ThreeDotsView {
    func setupSubviews() {
        addSubview(dotsStackView)
        dots.forEach({ dotsStackView.addArrangedSubview($0) })
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                dotsStackView.topAnchor.constraint(equalTo: topAnchor),
                dotsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                dotsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                dotsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
        )
    }
}

private extension ThreeDotsView {
    func subscribeForNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else {
                    return
                }
                self.isAnimating = model.isLoading
            }
        )
    }

    func removeNotificationsSubscriptions() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}
