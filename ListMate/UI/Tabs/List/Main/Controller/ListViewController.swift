//
//  ListViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class ListViewController: BaseViewController {
    
    private lazy var viewModel: ListViewModel = {
        let manager = DataManager()
        let model = ListViewModel(session: ProductSession.shared, manager: manager)
        model.delegate = self
        return model
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .singleLine
        view.delaysContentTouches = false
        view.backgroundColor = .mainGray
        view.register(ListCell.self, forCellReuseIdentifier: ListCell.description())
        return view
    }()
    
    private let emptyListLabel = CustomLabel(
        text: LanguageBase.list(.emptyListLabel).translate,
        textColor: .gray,
        font: .poppinsFont(size: 16, weight: .light),
        alignment: .center
    )
    
    // MARK: - Setup UI

    override func setupUIComponents() {
        super.setupUIComponents()
        navigationItem.title = LanguageBase.list(.title).translate
        configureNavBar()
        viewModel.readData()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    private func setupUI(){
        view.anchorFill(view: tableView)
        view.anchor(view: emptyListLabel) { kit in
            kit.centerX()
            kit.centerY()
        }
    }
    
    private func configureNavBar() {
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapNewList)
        )
        
        rightButton.tintColor = .mainGreen
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func updateUI(forEmptyList isEmpty: Bool) {
        emptyListLabel.isHidden = !isEmpty
    }
    
    private func checkIsListEmpty() {
        let isEmpty = self.viewModel.lists?.isEmpty ?? false
        self.updateUI(forEmptyList: isEmpty)
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapNewList() {
        let vc = NewListViewController()
        let nc = UINavigationController(rootViewController: vc)
        vc.viewModel.delegate = self
        nc.sheetPresentationController?.detents = [.custom(resolver: { context in
            return self.view.bounds.height / 3
        })]
        present(nc, animated: true)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkIsListEmpty()
        return viewModel.lists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ListCell.description(),
            for: indexPath) as? ListCell else { return UITableViewCell() }
        
        if let item = viewModel.lists?[indexPath.row] {
            cell.item = item
        }
        
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openItems(indexPath: indexPath.row)
    }
    
    func openItems(indexPath: Int) {
        guard let item = viewModel.lists?[indexPath] else { return }
        viewModel.updateListId(id: item.id.uuidString)
        let vc = ItemsViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel.quantityDelegate = self
        vc.title = item.name
        show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeConfiguration = SwipeActionsHandler.configureSwipeAction(for: tableView, at: indexPath) {
            self.viewModel.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return swipeConfiguration
    }
}

extension ListViewController: ListViewModelDelegate, NewListViewModelDelegate, ItemsQuantityDelegate {
    func showError(_ message: String) {
        let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateQuantity() {
        tableView.reloadData()
    }
}

