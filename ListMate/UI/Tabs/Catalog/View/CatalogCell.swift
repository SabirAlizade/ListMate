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
            configureCell()
        }
    }
    
    private var nameLabel = CustomLabel()
    private var priceLabel = CustomLabel()
    
    // MARK: - Setup UI
    
    private func configureCell() {
        guard let item else { return }
        nameLabel.text = item.name
        priceLabel.text = String(
            "\(Double.doubleToString(double: item.price.doubleValue)) \(LanguageBase.system(.currency).translate)"
        )
    }
    
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
