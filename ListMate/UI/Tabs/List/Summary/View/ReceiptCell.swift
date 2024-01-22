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
    
    private let dottedLineView: UIView = {
        let view = UIView()
        let border = CAShapeLayer()
        border .strokeColor = UIColor.gray.cgColor
        border.lineDashPattern = [2, 2]
        border.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 1)
        view.layer.addSublayer(border)
        return view
    }()
    
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
        
        self.anchor(view: priceLabel, completion: { kit in
            kit.trailing(25)
            kit.top(10)
            kit.bottom(10)
        })
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
