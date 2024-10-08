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
    func updateAmount(amount: Decimal128, id: ObjectId)
}

final class ItemCell: BaseCell {
    
    weak var delegate: ItemCellDelegate?
    var item: ItemModel? {
        didSet {
            configureCell()
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .maincell
        view.layer.shadowColor = UIColor.mainGreen.cgColor
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
    
    private lazy var priceLabel = CustomLabel(
        font: .poppinsFont(size: 20, weight: .medium),
        alignment: .right
    )
    
    private lazy var currencyLabel = CustomLabel(
        text: LanguageBase.system(.currency).translate,
        font: .poppinsFont(size: 20, weight: .medium),
        alignment: .center
    )
    
    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var checkBox: CheckBox = {
        let checkBox = CheckBox()
        checkBox.imageTint = .mainGreen
        checkBox.addTarget(self, action: #selector(changeCheckboxCheck), for: .valueChanged)
        return checkBox
    }()
    
    // MARK: - Setup UI
    
    override func setupCell() {
        super.setupCell()
        selectionStyle = .none
        setupUI()
    }
    
    private func configureCell() {
        guard let item else { return }
        nameLabel.text = item.name
        priceLabel.text = Double.doubleToString(double: item.totalPrice.doubleValue)
        itemAmountView.item = item
        checkBox.isChecked = item.isChecked
        loadImageData(from: item.imagePath)
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
            kit.width(50)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func changeCheckboxCheck() {
        let isCheckboxChecked = checkBox.isChecked ? false : true
        guard let id = item?.objectId else { return }
        delegate?.updateCheckmark(isChecked: isCheckboxChecked, id: id)
    }
    
    // MARK: - Image Loading
    
    private func loadImageData(from imageName: String? = nil) {
        guard let fileName = imageName else {
            itemImageView.image = UIImage(named: "noImage")
            return
        }
        
        if let cachedImage = ImageCacheManager.shared.getImage(forKey: fileName) {
            itemImageView.image = cachedImage
        } else {
            loadImageFromFile(fileName)
        }
    }
    
    private func loadImageFromFile(_ fileName: String) {
        guard let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            print("Library directory is not accessible")
            return
        }
        let fileURL = libraryDirectory.appendingPathComponent(fileName)
        
        if let image = UIImage(contentsOfFile: fileURL.path) {
            itemImageView.image = image
            ImageCacheManager.shared.setImage(image, forKey: fileName)
        } else {
            itemImageView.image = UIImage(named: "noImage")
        }
    }
}

extension ItemCell: ItemAmountDelegate {
    func setAmount(amount: Decimal128) {
        guard let id = item?.objectId else { return }
        delegate?.updateAmount(amount: amount, id: id)
    }
}

