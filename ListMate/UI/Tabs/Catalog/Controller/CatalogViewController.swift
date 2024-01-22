//
//  CatalogViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class CatalogViewController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.description())
        return view
    }()
    
    private lazy var viewModel: CatalogViewModel = {
        let model = CatalogViewModel()
        model.delegate = self
        return model
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        navigationItem.title = "Catalog"
        viewModel.readData()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    private func setupUI() {
        view.anchorFill(view: tableView)
    }
}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = viewModel.catalogItems else { return 0 }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.catalogItems?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.description(), for: indexPath) as? CatalogCell else { return UITableViewCell() }
        cell.item = item
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeConfiguration = SwipeActionsHandler.configureSwipeAction(for: tableView, at: indexPath) {
            self.viewModel.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return swipeConfiguration
    }
}

extension CatalogViewController: CatalogViewDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}
