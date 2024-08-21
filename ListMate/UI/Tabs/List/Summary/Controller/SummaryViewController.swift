//
//  SummaryViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import UIKit

class SummaryViewController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.isUserInteractionEnabled = false
        view.register(ReceiptCell.self, forCellReuseIdentifier: ReceiptCell.description())
        return view
    }()
    
    lazy var viewModel: SummaryViewModel = {
        return SummaryViewModel()
    }()
    
    // MARK: - Setup UI
    
    override func setupUIComponents() {
        super.setupUIComponents()
        closeBarButton()
        title = LanguageBase.summary(.title).translate
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    private func setupUI() {
        view.anchorFill(view: tableView)
    }
}

extension SummaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.summaryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptCell.description(), for: indexPath) as? ReceiptCell else {
            return UITableViewCell()
        }
        let item = viewModel.summaryItems[indexPath.row]
        cell.item = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return createFooterView()
    }
    
    private func createFooterView() -> UIView {
        let footerView = UIView()
        let totalLabel = CustomLabel(
            text: LanguageBase.summary(.totalLabel).translate,
            textColor: .mainText,
            font: .poppinsFont(size: 22, weight: .semiBold),
            alignment: .right
        )
        
        let totalAmount = CustomLabel(
            text: viewModel.countTotal(),
            textColor: .mainText,
            font: .poppinsFont(size: 22, weight: .semiBold),
            alignment: .right
        )
        
        let currencySign = CustomLabel(
            text: LanguageBase.system(.currency).translate,
            textColor: .mainText,
            font: .poppinsFont(size: 22, weight: .semiBold),
            alignment: .right
        )
        
        let hStack = UIView().HStack(
            views: totalAmount.withWidth(view.bounds.width / 2),
            currencySign,
            spacing: 5,
            distribution: .fill
        )
        
        footerView.anchor(view: hStack) { kit in
            kit.trailing(20)
            kit.top(40)
        }
        
        footerView.anchor(view: totalLabel) { kit in
            kit.trailing(hStack.leadingAnchor, 15)
            kit.top(40)
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView()
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView()
        
        let greetingLabel = CustomLabel(
            text: LanguageBase.summary(.thankLabel).translate,
            textColor: .gray,
            font: UIFont.monospacedSystemFont(ofSize: 14, weight: .regular),
            alignment: .center
        )
        
        greetingLabel.numberOfLines = 0
        
        headerView.anchor(view: greetingLabel) { kit in
            kit.centerX()
            kit.top(-40)
            kit.height(90)
            kit.width(160)
        }
        return headerView
    }
}
