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
            
        }
    }
    
    override func setupCell() {
        super.setupCell()
    }
}
