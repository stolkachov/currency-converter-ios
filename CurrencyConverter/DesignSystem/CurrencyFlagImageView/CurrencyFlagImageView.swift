//
//  CurrencyFlagImageView.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 29/03/2025.
//

import UIKit

final class CurrencyFlagImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 32, height: 32)
    }

    init() {
        super.init(frame: .zero)
        contentMode = .scaleAspectFit
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = bounds.width / 2
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1 / UIScreen.main.scale
    }

    func update(model: Model) {
        image = model.flag
        model.onFlagDidChange = { [weak self] flag in
            self?.image = flag
        }
    }
}
