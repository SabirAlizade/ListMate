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
//        view.image = UIImage(named: "noImage")
        return view
    }()
    
    override func setupCell() {
        super.setupCell()
    }
}
