//
//  ItemsViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit
import RealmSwift

typealias DiffableDataSource = UITableViewDiffableDataSource<String, ItemsModel>
typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, ItemsModel>

class ItemsViewController: BaseViewController {
    
    private lazy var dataSource: DiffableDataSource = {
        return .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            print(itemIdentifier)
            
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
        viewModel.readData()
           updateDataSource()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    private func setupUI() {
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
        var snapshot = DataSourceSnapshot()
        
        let group = Dictionary(grouping: viewModel.itemsArray) { $0.name }
        
        for (section, items) in group {
            //        snapshot.appendItems(viewModel.itemsArray)
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }
//        snapshot.appendItems(viewModel.itemsArray)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}


extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let item = dataSource.snapshot().itemIdentifiers[indexPath.row]
        //TODO:  IMPLEMENT ITEM DETILED
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ItemsViewController: ItemsModelDelegate, NewItemDelegate {
    func passAmountData(amount: Double) {
        tableView.reloadData()
    }
    
    func reloadData() {
        updateDataSource()
    }
}
