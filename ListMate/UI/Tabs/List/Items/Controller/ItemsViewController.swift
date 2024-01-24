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
    
    private lazy var summaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .poppinsFont(size: 18, weight: .regular)
        button.setTitle( "0.00", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "cart"), for: .normal)
        button.tintColor = .white
        button.layer.shadowColor = UIColor.maingreen.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.addTarget(self, action: #selector(didTapSummaryButton), for: .touchUpInside)
        return button
    }()
    
    private var emptyBagImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "emptybag")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var plusButton = FloatingButton(target: self, action: #selector(didTapAddItem))
    
    private lazy var activityIndicator: ActivityIndicator = {
        return ActivityIndicator.shared
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        activityIndicator.showActivityIndicator(view: view)
        configureNavBar()
        viewModel.readFilteredData() { [weak self] in
            self?.activityIndicator.stopActivityIndicator()
        }
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        configureSummaryButton()
        setupUI()
    }
    
    private func configureSummaryButton() {
        viewModel.updateSummaryButton = { [weak self] amount in
            let amountString = Double.doubleToString(double: amount )
            self?.summaryButton.setTitle(" \(amountString) $", for: .normal)
        }
    }
    
    private func configureNavBar() {
        let summarybutton = UIBarButtonItem(customView: summaryButton)
        if let customView = summarybutton.customView {
            customView.withWidth(115)
            customView.withHeight(35)
        }
        navigationItem.rightBarButtonItem = summarybutton
        navigationController?.navigationBar.tintColor = .maingreen
    }
    
    private func setupUI() {
        view.anchorFill(view: tableView)
        
        view.anchor(view: emptyBagImage) { kit in
            kit.centerX()
            kit.centerY()
        }
        
        view.anchor(view: plusButton) { kit in
            kit.trailing(20)
            kit.bottom(40, safe: true)
        }
    }
    
    private func updateUI(forEmptyList isEmpty: Bool) {
        emptyBagImage.isHidden = !isEmpty
        summaryButton.isEnabled = !isEmpty
        summaryButton.backgroundColor = isEmpty ? .maingreen.withAlphaComponent(0.5) : .maingreen
    }
    
    @objc
    private func didTapAddItem() {
        let vc  = NewItemViewController()
        vc.viewModel.delegate = self
        vc.title = "New Item"
        let nc = UINavigationController(rootViewController: vc)
        nc.sheetPresentationController?.detents = [.large()]
        present(nc, animated: true)
    }
    
    @objc
    private func didTapSummaryButton() {
        let vc = SummaryViewController()
        vc.viewModel.updateItems(items: viewModel.completedItemsArray)
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
}

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionsCount = viewModel.getSections().count
        updateUI(forEmptyList: sectionsCount == 0 ? true : false)
        return sectionsCount
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
        return 95
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeConfiguration = SwipeActionsHandler.configureSwipeAction(for: tableView, at: indexPath) {
            self.viewModel.removeRow(indexPath: indexPath)
            
            let areAllSectionsEmpty = self.viewModel.getSections().allSatisfy { $0.data.isEmpty }
            self.updateUI(forEmptyList: areAllSectionsEmpty)
        }
        return swipeConfiguration
    }
}

extension ItemsViewController: NewItemDelegate, ItemsModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateItemsData() {
        viewModel.readFilteredData(completion: {})
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

extension ItemsViewController: DetailedViewModelDelegate {
    func updateChanges() {
        tableView.reloadData()
    }
}
