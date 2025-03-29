//
//  CurrenciesListViewController.swift
//  CurrencyConverter
//
//  Created by Semen Tolkachov on 28/03/2025.
//

import UIKit

final class CurrenciesListViewController: UITableViewController {
    private let viewModel: CurrenciesListViewModel

    init(viewModel: CurrenciesListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose currency"
        setupTableView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CurrenciesListCurrencyTableViewCell.self),
            for: indexPath
        ) as? CurrenciesListCurrencyTableViewCell else {
            assertionFailure()
            return UITableViewCell()
        }

        if let model = viewModel.displayModels[safe: indexPath.row] {
            cell.update(model: model)
        } else {
            assertionFailure()
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectCurrencyAtIndex(index: indexPath.row)
    }
}

private extension CurrenciesListViewController {
    func setupTableView() {
        tableView.register(CurrenciesListCurrencyTableViewCell.self, forCellReuseIdentifier: String(describing: CurrenciesListCurrencyTableViewCell.self))
    }
}
