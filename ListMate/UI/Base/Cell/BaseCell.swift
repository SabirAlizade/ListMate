//
//  BaseCell.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class BaseCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    func setupCell() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

