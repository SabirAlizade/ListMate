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
            configureCell()
        }
    }
    
    private let nameLabel = CustomLabel(font: .poppinsFont(size: 18, weight: .medium))
    private let completedLabel = CustomLabel(textColor: .mainGreen)
    private let totalLabel = CustomLabel(textColor: .darkGray)
  
    // MARK: - Setup UI

    override func setupCell() {
        super.setupCell()
        setupUI()
    }
    
    private func setupUI() {
        self.anchor(view: nameLabel) { kit in
            kit.centerY()
            kit.leading(16)
        }
        
        self.anchor(view: totalLabel) { kit in
            kit.trailing(40)
            kit.centerY()
        }
        
        self.anchor(view: completedLabel) { kit in
            kit.trailing(totalLabel.leadingAnchor, 2)
            kit.centerY()
        }
    }
    
    private func configureCell() {
        guard let item = item else { return }
        nameLabel.text = item.name
        completedLabel.text = "\(item.completedQuantity)"
        totalLabel.text = "/\(item.totalItemQuantity)"
    }
}
