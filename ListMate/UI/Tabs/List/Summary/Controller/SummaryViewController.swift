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
        let model = SummaryViewModel()
        return model
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        closeBarButton()
        title = "Summary"
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
        let item = viewModel.summaryItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptCell.description(), for: indexPath) as? ReceiptCell else { return UITableViewCell() }
        cell.item = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let footerLabel = CustomLabel(text: "TOTAL:  \(viewModel.countTotal()) $",
                                      textColor: .maintext,
                                      font: .poppinsFont(size: 22, weight: .semiBold),
                                      alignment: .right)
        
        footerView.anchor(view: footerLabel) { kit in
            kit.trailing(20)
            kit.top(40)
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let greetingLabel = CustomLabel(text: "THANK YOU!\nfor using\nListMate",
                                        textColor: .gray,
                                        font: UIFont.monospacedSystemFont(ofSize: 19, weight: .regular),
                                        alignment: .center)
        
        greetingLabel.numberOfLines = 0
        
        headerView.anchor(view: greetingLabel) { kit in
            kit.centerX()
            kit.top(-40)
            kit.height(90)
            kit.width(120)
        }
        return headerView
    }
}
