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
    
    private var snapshot = DataSourceSnapshot()
    
    
    private lazy var dataSource: DiffableDataSource = {
        return .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            print(itemIdentifier)
            
            let cell = tableView.reuseCell(ItemCell.self, indexPath: indexPath)
            cell.item = itemIdentifier
            //            cell.delegate = self
            return cell
        }
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.separatorStyle = .none
        view.sectionIndexBackgroundColor = .red
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
        vc.viewModel.delegate = self
        present(nc, animated: true)
    }
    
    private func updateDataSource() {
        let group = Dictionary(grouping: viewModel.itemsArray) { $0.notes }//TODO: CHANGE TO TIME ORDER
        
        for (section, items) in group {
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //   let item = dataSource.snapshot().itemIdentifiers[indexPath.row]
        //TODO:  IMPLEMENT ITEM DETILED
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension ItemsViewController: NewItemDelegate/*ItemsModelDelegate*/ /*ItemCellDelegate*/   {
    func reloadData() {
  //TODO: DOESNT WORK
        tableView.reloadData()
    }
    
    //    func didTapPlusButton(in cell: ItemCell) {
    //        viewModel.plusButtonAction()
    //        print("+")
    //    }
    //
    //    func didTapMinusButton(in cell: ItemCell) {
    //        viewModel.minusButtonAction()
    //        print("-")
    //    }
    
    //    func didUpdateText(in cell: ItemCell, newText: String) {
    //
    //    }
    
    func passAmountData(amount: Double) {
        tableView.reloadData()
    }
}
