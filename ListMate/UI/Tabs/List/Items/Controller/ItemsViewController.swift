//
//  ItemsViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit
import RealmSwift

typealias DiffableDataSource = UITableViewDiffableDataSource<String, ItemModel>
typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, ItemModel>

class ItemsViewController: BaseViewController {
    
    private var snapshot = DataSourceSnapshot()
    
    
    private lazy var dataSource: DiffableDataSource = {
        return .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            
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
    
    lazy var summaryButton = CustomButton(title: "15 $",
                                          backgroundColor: .maingreen,
                                          titleColor: .white,
                                          target: self,
                                          action:  #selector(summaryButtonTapped))
    
    private lazy var plusButton = FloatingButton(target: self, action:  #selector (didTapAddItem))
    
    override func setupUIComponents() {
        super.setupUIComponents()
        configureNavBar()
        viewModel.readData()
        updateDataSource()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        tabBarController?.tabBar.isHidden = true
        setupUI()
    }
    
    private func configureNavBar() {
        let summarybtn = UIBarButtonItem(customView: summaryButton)
        summarybtn.width = 90
        summarybtn.customView?.withHeight(35)
        summarybtn.customView?.layer.shadowOpacity = 5
        summarybtn.customView?.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationItem.rightBarButtonItem = summarybtn
        navigationController?.navigationBar.tintColor = .maingreen
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
    
    @objc
    private func summaryButtonTapped() {
        let vc = SummaryViewController()
        let nc = UINavigationController(rootViewController: vc)
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
//        let item = dataSource.snapshot().itemIdentifiers[indexPath.row]
        openDetailed(indexPath: indexPath.row)
    }
    
    func openDetailed(indexPath: Int) {
        let item = dataSource.snapshot().itemIdentifiers[indexPath].name
        let vc = DetailedViewController()
        vc.title = item
        let nc = UINavigationController(rootViewController: vc)
        nc.sheetPresentationController?.detents = [.large()]
        present(nc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] ( action, view, completionHandler) in
            guard let item = self?.dataSource.snapshot().itemIdentifiers[indexPath.row] else { return }
            self?.viewModel.deleteItem(item: item)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        action.backgroundColor = .white
        action.image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [action])
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

//#Preview {
//    ItemsViewController()
//}
