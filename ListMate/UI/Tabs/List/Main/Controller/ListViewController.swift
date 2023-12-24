//
//  ListViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class ListViewController: BaseViewController {
    
    private lazy var viewModel: ListViewModel = {
        let model = ListViewModel(session: .shared)
        model.delegate = self
        return model
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(ListCell.self, forCellReuseIdentifier: ListCell.description())
        return view
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        configureNavBar()
        viewModel.readData()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    private func setupUI(){
        view.anchorFill(view: tableView)
    }
    
    private func configureNavBar() {
        navigationItem.title = "Lists"
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapNewList))
        
        rightButton.tintColor = .maingreen
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc
    private func didTapNewList() {
        let vc = NewListViewController()
        let nc = UINavigationController(rootViewController: vc)
        vc.viewModel.delegate = self
        nc.sheetPresentationController?.detents = [.custom(resolver: { context in
            return self.view.bounds.height / 4
        }
                                                          )]
        present(nc, animated: true)    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.lists?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.description(),
                                                       for: indexPath) as? ListCell else { return UITableViewCell() }
        cell.item = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openItems(indexPath: indexPath.row)
    }
    
    func openItems(indexPath: Int) {
        guard let item = viewModel.lists?[indexPath] else { return }
        viewModel.updateListId(id: item.id.uuidString)
        let vc = ItemsViewController()
        vc.title = item.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ListViewController: ListViewModelDelegate, NewListViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}
