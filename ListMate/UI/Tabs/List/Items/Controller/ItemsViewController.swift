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
    
    lazy var summaryButton = CustomButton(title: "0.0",
                                          backgroundColor: .maingreen,
                                          titleColor: .white,
                                          target: self,
                                          action:  #selector(summaryButtonTapped))
    
    private lazy var plusButton = FloatingButton(target: self, action:  #selector (didTapAddItem))
    
    override func setupUIComponents() {
        super.setupUIComponents()
        configureNavBar()
        viewModel.readFilteredData()
        configureSummaryButton()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    func configureSummaryButton() {
        viewModel.updateSummaryButton = { [weak self] amount in
            let amountString = Double.doubleToString(double: amount )
            self?.summaryButton.setTitle("Total:  \(amountString) $", for: .normal)
        }
    }
    
    private func configureNavBar() {
        
        let summarybtn = UIBarButtonItem(customView: summaryButton)
        summarybtn.width = 95
        summarybtn.customView?.withHeight(35)
        summarybtn.customView?.layer.shadowOpacity = 5
        summarybtn.customView?.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationItem.rightBarButtonItem = summarybtn
        navigationController?.navigationBar.tintColor = .maingreen
    }
    
    private func setupUI() {
        view.anchorFill(view: tableView)
        
        view.anchor(view: plusButton) { kit in
            kit.trailing(20)
            kit.bottom(40, safe: true)
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
        print(viewModel.completedItemsArray)
        vc.viewModel.updateItems(items: viewModel.completedItemsArray)
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
}

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSections().count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sectionHeaderTitle(for: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSections()[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.description(), for: indexPath) as? ItemCell else { return UITableViewCell() }
        let item = viewModel.getSections()[indexPath.section].data[indexPath.row]
        cell.delegate = self
        cell.item = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailed(indexPath: indexPath)
    }
    
    func openDetailed(indexPath: IndexPath) {
        let item = viewModel.getSections()[indexPath.section].data[indexPath.row]
        let vc = DetailedViewController()
        vc.viewModel.item = item
        vc.viewModel.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        nc.sheetPresentationController?.detents = [.large()]
        present(nc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let swipeConfiguration = SwipeActionsHandler.configureSwipeAction(for: tableView, at: indexPath) {
            self.viewModel.removeRow(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return swipeConfiguration
    }
}

extension ItemsViewController: NewItemDelegate, ItemsModelDelegate, DetailedViewModelDelegate {
    
    func updateChanges() {
        //        tableView.reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadAndFilterData() {
        viewModel.readFilteredData()
    }
}

extension ItemsViewController: ItemCellDelegate {
    func updateCheckmark(isChecked: Bool, id: ObjectId) {
        viewModel.updateCheckmark(isCheked: isChecked, id: id)
    }
    
    func updateAmount(amount: Double, id: ObjectId) {
        viewModel.updateAmount(amount: amount, id: id)
    }
}
