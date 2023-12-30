//
//  ListCell.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class ListCell: BaseCell {
    
    var item: ListModel? {
        didSet {
            guard let item = item else { return }
            nameLabel.text = item.name
            completedLabel.text = "\(item.completedQuantity)"
            totalLabel.text = "/\(item.totalItemQuantity)"
        }
    }
    
    private let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOpacity = 0.5
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    
    private let nameLabel = CustomLabel( font: .poppinsFont(size: 18, weight: .medium))
    private let completedLabel = CustomLabel(textColor: .maingreen)
    private let totalLabel = CustomLabel(textColor: .darkGray)
        
    override func setupCell() {
        super.setupCell()
        selectionStyle = .none
        setupUI()
    }
    
    private func setupUI() {
        self.anchor(view: containerView) { kit in
            kit.leading(15)
            kit.trailing(15)
            kit.top(10)
            kit.bottom(10)
        }
        containerView.anchor(view: nameLabel) { kit in
            kit.centerY()
            kit.leading(16)
        }
        
        containerView.anchor(view: totalLabel) { kit in
            kit.trailing(16)
            kit.centerY()
        } 
        
        containerView.anchor(view: completedLabel) { kit in
            kit.trailing(totalLabel.leadingAnchor, 2)
            kit.centerY()
        }
    }
}

#Preview {
    ListCell()
}
