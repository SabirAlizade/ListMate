//
//  ItemCelll.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

protocol ItemCellDelegate: AnyObject {
    func updateCheckmark(cell: ItemCell, isChecked: Bool)
    func updateAmount(cell: ItemCell, amount: Double)
}

final class ItemCell: BaseCell {
    weak var delegate: ItemCellDelegate?
    
    var item: ItemModel? {
        didSet {
            guard let item else { return }
            nameLabel.text = item.name
            priceLabel.text = String(format: "%.1f", item.totalPrice)
            itemAmountView.item = item
            checkBox.isChecked = item.isBought
            if let image = UserDefaults.standard.readImage(key: item.image) {
                itemImageView.image = image
            }
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOpacity = 4
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    }()
    
    private lazy var itemAmountView: ItemAmountView = {
        let view = ItemAmountView()
        view.delegate = self
        view.amountTextField.isUserInteractionEnabled = false
        return view
    }()
    
    private let nameLabel = CustomLabel(font: .poppinsFont(size: 22, weight: .regular))
    private lazy var priceLabel = CustomLabel(font: .poppinsFont(size: 20, weight: .medium), alignment: .center)
    
    private lazy var currencyLabel = CustomLabel(text: "$", font: .poppinsFont(size: 20, weight: .medium), alignment: .center)
    
    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var checkBox: CheckBox = {
        let checkBox = CheckBox()
        checkBox.imageTint = .maingreen
        checkBox.addTarget(self, action: #selector(changeCheck), for: .valueChanged)
        return checkBox
    }()
        
    override func setupCell() {
        super.setupCell()
        selectionStyle = .none
        setupUI()
    }
    
    @objc
    func changeCheck() {
        let isChecked = checkBox.isChecked ? false : true
        delegate?.updateCheckmark(cell: self, isChecked: isChecked)
    }
    
    private func setupUI() {
        
        contentView.anchor(view: containerView) { kit in
            kit.leading(5)
            kit.trailing(5)
            kit.top(10)
            kit.bottom(10)
        }
        
        containerView.anchor(view: itemImageView) { kit in
            kit.centerY()
            kit.leading(15)
            kit.width(50)
            kit.height(50)
        }
        
        containerView.anchor(view: nameLabel) { kit in
            kit.leading(itemImageView.trailingAnchor, 15)
            kit.top(containerView.topAnchor, 5)
        }
        
        containerView.anchor(view: itemAmountView) { kit in
            kit.leading(nameLabel.leadingAnchor)
            kit.top(nameLabel.bottomAnchor, 5)
            kit.width(180)
            kit.height(35)
        }
        
        containerView.anchor(view: checkBox) { kit in
            kit.trailing(15)
            kit.centerY()
            kit.width(30)
            kit.height(30)
        }
        
        containerView.anchor(view: currencyLabel) { kit in
            kit.trailing(checkBox.leadingAnchor, 10)
            kit.centerY()
        }
        
        containerView.anchor(view: priceLabel) { kit in
            kit.trailing(currencyLabel.leadingAnchor, 5)
            kit.centerY()
        }
    }
}

extension ItemCell: ItemAmountDelegate {
    func setAmount(amount: Double) {
        delegate?.updateAmount(cell: self, amount: amount)
    }
}
