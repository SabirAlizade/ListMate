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
            amountLabel.text =  String("x \(checkTrailingZeros(amount: item.amount))")
            priceLabel.text =  String("\(item.totalPrice) $")
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
    
    private func checkTrailingZeros(amount: Double) -> String {
        var amountString = String(format: "%.1f", amount)
        if amountString.hasSuffix(".0") {
            amountString = String(amountString.dropLast(2))
        }
        return amountString
    }
}
