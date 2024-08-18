//
//  ReceiptCell.swift
//  ListMate
//
//  Created by Sabir Alizade on 28.12.23.
//

import UIKit
import RealmSwift

class ReceiptCell: BaseCell{
    
    var item: ItemModel? {
        didSet {
            guard let item else { return }
            nameLabel.text = item.name
            amountLabel.text =  String("x \(item.amount)")
            priceLabel.text = String(Double.doubleToString(double: item.totalPrice.doubleValue))
            currencyLabel.text = String(LanguageBase.system(.currency).translate)
        }
    }
    
    private let nameLabel = CustomLabel(
        textColor: .gray,
        font: .poppinsFont(size: 18, weight: .medium),
        alignment: .left
    )
    
    private let amountLabel = CustomLabel(
        textColor: .gray,
        font: .poppinsFont(size: 16, weight: .light),
        alignment: .left
    )
    
    private let priceLabel = CustomLabel(
        textColor: .gray,
        font: .poppinsFont(size: 20, weight: .light),
        alignment: .right
    )
    
    private let currencyLabel = CustomLabel(
        textColor: .gray,
        font: .poppinsFont(size: 20, weight: .light),
        alignment: .right
    )
    
    override func setupCell() {
        super.setupCell()
        setupUI()
        addDottedLine()
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
        
        self.anchor(view: currencyLabel) { kit in
            kit.trailing(25)
            kit.top(10)
            kit.bottom(10)
        }
        
        self.anchor(view: priceLabel, completion: { kit in
            kit.trailing(currencyLabel.leadingAnchor, 5)
            kit.top(10)
            kit.bottom(10)
        })
        
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: self.bounds.width / 2),
            priceLabel.widthAnchor.constraint(lessThanOrEqualToConstant: self.bounds.width / 3)
        ])
    }
    
    private func addDottedLine() {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.lightGray.cgColor
        borderLayer.lineWidth = 1
        borderLayer.lineDashPattern = [5, 5]
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: contentView.bounds.minX + 25, y: contentView.bounds.maxY))
        path.addLine(to: CGPoint(x: contentView.bounds.maxX, y: contentView.bounds.maxY))
        
        borderLayer.path = path.cgPath
        contentView.layer.addSublayer(borderLayer)
    }
}
