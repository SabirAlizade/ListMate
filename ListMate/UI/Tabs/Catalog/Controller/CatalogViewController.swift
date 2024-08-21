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
        view.backgroundColor = .mainGray
        view.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.description())
        return view
    }()
    
    private lazy var viewModel: CatalogViewModel = {
        let model = CatalogViewModel()
        model.delegate = self
        return model
    }()
    
    // MARK: - Setup UI
    
    override func setupUIComponents() {
        super.setupUIComponents()
        navigationItem.title = LanguageBase.catalog(.title).translate
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadCatalog),
            name: NSNotification.Name("ReloadCatalogData"),
            object: nil
        )
        viewModel.readData()
        viewModel.loadMockData()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    private func setupUI() {
        view.anchorFill(view: tableView)
    }
    
    // MARK: - Actions
    
    @objc
    private func reloadCatalog() {
        viewModel.readData()
    }
}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.catalogItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.description(), for: indexPath) as? CatalogCell else {
            return UITableViewCell()
        }
        let item = viewModel.catalogItems?[indexPath.row]
        cell.item = item
        cell.selectionStyle = .none
        cell.backgroundColor = .mainGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeConfiguration = SwipeActionsHandler.configureSwipeAction(for: tableView, at: indexPath) {
            self.viewModel.deleteItem(index: indexPath.row)
        }
        return swipeConfiguration
    }
}

extension CatalogViewController: CatalogViewDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}
