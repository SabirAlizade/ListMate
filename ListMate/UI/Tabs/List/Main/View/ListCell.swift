//
//  ListCell.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class ListCell: BaseCell {
    
    var item: ListModel? {
        didSet {
            guard let item = item else { return }
            nameLabel.text = item.name
        }
    }
    
    private let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOpacity = 8
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsFont(size: 18, weight: .medium)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    override func setupCell() {
        super.setupCell()
        selectionStyle = .none
        setupUI()
    }
    
    private func setupUI() {
        self.anchor(view: containerView) { kit in
            kit.leading(10)
            kit.trailing(10)
            kit.top(10)
            kit.bottom(10)
        }
        containerView.anchor(view: nameLabel) { kit in
            kit.centerY()
            kit.leading(16)
        }
    }
}
