//
//  ReceiptCell.swift
//  ListMate
//
//  Created by Sabir Alizade on 28.12.23.
//

import UIKit
class ReceiptCell: BaseCell{
    
    var item: ItemModel? {
        didSet {
            guard let item else { return }
            nameLabel.text = item.name
            amountLabel.text =  String("x \(Double.doubleToString(double: item.amount))")
            priceLabel.text = String("\(Double.doubleToString(double: item.totalPrice)) $")
            
        }
    }
    
    private let nameLabel = CustomLabel(textColor: .gray,
                                        font: .poppinsFont(size: 18, weight: .medium),
                                        alignment: .left)
    private let amountLabel = CustomLabel(textColor: .gray,
                                          font: .poppinsFont(size: 16, weight: .light),
                                          alignment: .left)
    private let priceLabel = CustomLabel(textColor: .gray,
                                         font: .poppinsFont(size: 20, weight: .light),
                                         alignment: .left)
    
    override func setupCell() {
        super.setupCell()
        setupUI()
    }
    
    private func setupUI() {
        
        self.anchor(view: nameLabel, completion: { kit in
            kit.leading(25)
            kit.top(10)
            kit.bottom(10)
        })
        
        self.anchor(view: amountLabel, completion: { kit in
            kit.leading(nameLabel.trailingAnchor, 20)
            kit.top(10)
            kit.bottom(10)
        })
        
        self.anchor(view: priceLabel, completion: { kit in
            kit.trailing(25)
            kit.top(10)
            kit.bottom(10)
        })
    }
}
