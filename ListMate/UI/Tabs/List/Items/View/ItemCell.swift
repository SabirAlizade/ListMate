//
//  ItemCelll.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit
import RealmSwift

protocol ItemCellDelegate: AnyObject {
    func updateCheckmark(isChecked: Bool, id: ObjectId)
    func updateAmount(amount: Double, id: ObjectId)
}

final class ItemCell: BaseCell {
    weak var delegate: ItemCellDelegate?
    
    var item: ItemModel? {
        didSet {
            guard let item else { return }
            nameLabel.text = item.name
            priceLabel.text = Double.doubleToString(double: item.totalPrice)
            itemAmountView.item = item
            checkBox.isChecked = item.isBought
            loadImageData(imageName: item.image)
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .maincell
        view.layer.shadowColor = UIColor.maingreen.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        return view
    }()
    
    private lazy var itemAmountView: ItemAmountView = {
        let view = ItemAmountView()
        view.delegate = self
        view.amountTextField.isUserInteractionEnabled = false
        return view
    }()
    
    private let nameLabel = CustomLabel(font: .poppinsFont(size: 22, weight: .regular))
    private lazy var priceLabel = CustomLabel(font: .poppinsFont(size: 20, weight: .medium),
                                              alignment: .right)
    private lazy var currencyLabel = CustomLabel(text: "$",
                                                 font: .poppinsFont(size: 20, weight: .medium),
                                                 alignment: .center)
    
    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var checkBox: CheckBox = {
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
    private func changeCheck() {
        let isChecked = checkBox.isChecked ? false : true
        guard let id = item?.objectId else { return }
        delegate?.updateCheckmark(isChecked: isChecked, id: id)
    }
    
    private func setupUI() {
        
        contentView.anchor(view: containerView) { kit in
            kit.leading(15)
            kit.trailing(15)
            kit.top(6)
            kit.bottom(6)
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
            kit.width(200)
        }
        
        containerView.anchor(view: itemAmountView) { kit in
            kit.leading(nameLabel.leadingAnchor)
            kit.top(nameLabel.bottomAnchor, 5)
            kit.width(140)
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
            kit.width(70)
        }
    }
    
    private func loadImageData(imageName: String?) {
        if let fileName = imageName {
            if let cachedImage = ImageCacheManager.shared.getImage(forKey: fileName) {
                itemImageView.image = cachedImage
            } else {
                let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
                let fileURL = libraryDirectory.appendingPathComponent(fileName)

                if let image = UIImage(contentsOfFile: fileURL.path) {
                    itemImageView.image = image
                    ImageCacheManager.shared.setImage(image, forKey: fileName)
                } else {
                    itemImageView.image = UIImage(named: "noImage")
                }
            }
        } else {
            itemImageView.image = UIImage(named: "noImage")
        }
    }
}

extension ItemCell: ItemAmountDelegate {
    func setAmount(amount: Double) {
        guard let id = item?.objectId else { return }
        delegate?.updateAmount(amount: amount, id: id)
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
