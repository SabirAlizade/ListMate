//
//  ListViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class ListViewController: BaseViewController {
    
    private lazy var viewModel: ListViewModel = {
        let model = ListViewModel()
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
        //   setupLargeTitle(title: "List")
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
    }
    
    private func configureNavBar() {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapNewList))
        
        rightButton.tintColor = .maingreen
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc
    private func didTapNewList() {
        
    }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ListViewController: ListViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}
