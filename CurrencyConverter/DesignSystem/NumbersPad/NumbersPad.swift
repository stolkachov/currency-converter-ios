//
//  NumbersPad.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit

final class NumbersPad: UIView {
    private lazy var rowsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(model: Model) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        makeButtonsStack(model: model)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NumbersPad {
    func makeButtonsStack(model: Model) {
        model.buttons.forEach({ row in
            let singleRowStackView = makeSingleRowStackView()

            row.forEach({ button in
                let button = NumbersPadButton(model: button)
                singleRowStackView.addArrangedSubview(button)
            })

            rowsStackView.addArrangedSubview(singleRowStackView)
        })
    }

    func makeSingleRowStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20.0
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}

private extension NumbersPad {
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(rowsStackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                rowsStackView.topAnchor.constraint(equalTo: topAnchor),
                rowsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                rowsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                rowsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
}
