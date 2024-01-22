//
//  SuggestionCell.swift
//  ListMate
//
//  Created by Sabir Alizade on 29.12.23.
//

import UIKit

class SuggestionCell: UICollectionViewCell {
    
    var item: CatalogModel? {
        didSet {
            guard let item else { return }
            nameLabel.text = item.name
        }
    }
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .maincell
        return view
    }()
    
    private lazy var nameLabel = CustomLabel()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "plus.square.fill")
        view.contentMode = .scaleAspectFit
        view.tintColor = .maingreen
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        let hStack = UIView().HStack(views: nameLabel, iconView.withWidth(25).withHeight(25),
                                     spacing: 10, distribution: .fill)
        
        self.anchor(view: bubbleView) { kit in
            kit.leading(5)
            kit.trailing(5)
            kit.top()
            kit.width(120)
            kit.bottom()
        }
        
        bubbleView.anchor(view: hStack) { kit in
            kit.leading(10)
            kit.trailing(10)
            kit.top(2)
            kit.bottom(2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
