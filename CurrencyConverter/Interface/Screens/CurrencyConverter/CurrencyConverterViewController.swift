//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 27/03/2025.
//

import UIKit

final class CurrencyConverterViewController: UIViewController {
    private lazy var tradeCurrencyPairView: TradeCurrencyPairView = {
        let view = TradeCurrencyPairView(model: viewModel.tradeCurrencyPairModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var numbersPad: NumbersPad = {
        let view = NumbersPad(model: viewModel.numbersPadModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.backgroundShallow.cgColor, UIColor.backgroundDeep.cgColor]
        return layer
    }()

    private let viewModel: CurrencyConverterViewModel

    init(viewModel: CurrencyConverterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        bindViewModel()
        viewModel.onViewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
}

private extension CurrencyConverterViewController {
    func bindViewModel() {
        viewModel.onTitleChange = { [weak self] title in
            self?.title = title
        }
        viewModel.onSelectedCurrencyViewChange = { [weak self] isSellCurrencyViewSelected in
            if isSellCurrencyViewSelected {
                self?.tradeCurrencyPairView.selectSellCurrencyView()
            } else {
                self?.tradeCurrencyPairView.selectBuyCurrencyView()
            }
        }
    }
}

private extension CurrencyConverterViewController {
    func setupSubviews() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        view.addSubview(tradeCurrencyPairView)
        view.addSubview(numbersPad)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                tradeCurrencyPairView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
                tradeCurrencyPairView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 16),
                tradeCurrencyPairView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -16),
                tradeCurrencyPairView.bottomAnchor.constraint(lessThanOrEqualTo: numbersPad.topAnchor, constant: -24),

                numbersPad.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                numbersPad.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
                numbersPad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
                numbersPad.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ]
        )
    }
}
