//
//  CatalogCell.swift
//  ListMate
//
//  Created by Sabir Alizade on 29.12.23.
//

import UIKit

class CatalogCell: BaseCell {
    
    var item: CatalogModel? {
        didSet {
            guard let item else { return }
            nameLabel.text = item.name
            priceLabel.text = "\(item.price) $"
        }
    }
    
    private var nameLabel = CustomLabel()
    private var priceLabel = CustomLabel()
    
    override func setupCell() {
        super.setupCell()
        setupUI()
    }
    
    private func setupUI() {
        self.anchor(view: nameLabel) { kit in
            kit.leading(15)
            kit.centerY()
        }
        
        self.anchor(view: priceLabel) { kit in
            kit.trailing(15)
            kit.centerY()
        }
    }
}
