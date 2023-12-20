//
//  ItemsViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

typealias DiffableDataSource = UITableViewDiffableDataSource<String, ItemsModel>
typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, ItemsModel>

class ItemsViewController: BaseViewController {
    
    private lazy var dataSource: DiffableDataSource = {
        return .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.reuseCell(ItemCell.self, indexPath: indexPath)
            cell.item = itemIdentifier
            return cell
        }
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.register(ItemCell.self)
        return view
    }()
    
    lazy var viewModel: ItemsViewModel = {
        let model = ItemsViewModel()
        return model
    }()
    
    private lazy var plusButton = FloatingButton(target: self, action:  #selector (didTapAddItem))
    
    override func setupUIComponents() {
        super.setupUIComponents()
        updateDataSource()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        view.anchorFill(view: tableView)
        
        
        view.anchor(view: plusButton) { kit in
            kit.trailing(30)
            kit.bottom(30, safe: true)
        }
        
        
    }
    
    @objc
    private func didTapAddItem() {
        let vc  = NewItemViewController()
        let nc = UINavigationController(rootViewController: vc)
        nc.sheetPresentationController?.detents = [.medium()]
        vc.title = "New Item"
        present(nc, animated: true)
    }
    
    private func updateDataSource() {
        let snapshot = DataSourceSnapshot()
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.snapshot().itemIdentifiers[indexPath.row]
        //TODO:  IMPLEMENT ITEM DETILED
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ItemsViewController: ItemsModelDelegate {
    func reloadData() {
        updateDataSource()
    }
}
