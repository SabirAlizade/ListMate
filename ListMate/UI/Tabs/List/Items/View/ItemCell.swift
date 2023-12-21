//
//  ItemCelll.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

class ItemCell: BaseCell {
    
    var item: ItemsModel? {
        didSet {
            guard let item = item else { return }
            nameLabel.text = item.name
            priceLabel.text = "\(item.price)"
            if let image = UserDefaults.standard.readImage(key: item.image) {
                itemImageView.image = image
            }
            print("ZZZZZ \(item)")
        }
    }
    
    private let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOpacity = 2
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    
    private let nameLabel = CustomLabel()
    private let priceLabel = CustomLabel()
    
    //TODO: CHECKMARK
    
    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func setupCell() {
        super.setupCell()
        setupUI()
    }
    private func setupUI() {
        
        let hStack = UIView().HStack(views: itemImageView, nameLabel, priceLabel)
        
        self.anchor(view: containerView) { kit in
            kit.leading(10)
            kit.trailing(10)
            kit.top()
            kit.bottom()
        }
        
        
        containerView.anchor(view: hStack) { kit in
            kit.centerY()
            kit.leading(16)
        }
    }
}
