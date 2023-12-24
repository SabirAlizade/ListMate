//
//  ItemsViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit
import RealmSwift

class ItemsViewController: BaseViewController {
    
    lazy var viewModel: ItemsViewModel = {
        let model = ItemsViewModel(session: .shared)
        model.delegate = self
        return model
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.delaysContentTouches = false
        view.register(ItemCell.self, forCellReuseIdentifier: ItemCell.description())
        return view
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
        viewModel.filter()
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
        vc.viewModel.delegate = self
        vc.title = "New Item"
        let nc = UINavigationController(rootViewController: vc)
        nc.sheetPresentationController?.detents = [.medium()]
        present(nc, animated: true)
    }
    
    @objc
    private func summaryButtonTapped() {
        let vc = SummaryViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
}

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.description(), for: indexPath) as? ItemCell else  { return UITableViewCell() }
        cell.item = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailed(indexPath: indexPath.row)
    }
    
    func openDetailed(indexPath: Int) {
        let item = viewModel.items?[indexPath].name
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
        let swipeConfiguration = SwipeActionsHandler.configureSwipeAction(for: tableView, at: indexPath) { [weak self] in
            guard let item = self?.viewModel.items?[indexPath.row] else { return }
            self?.viewModel.deleteItem(item: item)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return swipeConfiguration
    }
}

extension ItemsViewController: NewItemDelegate, ItemsModelDelegate {
    func reloadAndFilterData() {
        viewModel.filter()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
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

//    func passAmountData(amount: Double) {
//        tableView.reloadData()
//    }


//#Preview {
//    ItemsViewController()
//}
