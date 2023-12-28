//
//  SummaryViewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 28.12.23.
//

import Foundation

protocol SummaryViewModelDelegate: AnyObject {
    func reloadData()
}

class SummaryViewModel {
    
    weak var delegate: SummaryViewModelDelegate?
    
    private var items: [ItemModel] = []
    
    func updateItems(items: [ItemModel]) {
        self.items = items
        print(items)
    }
    
    func countTotal() -> String {
        let sum = items.reduce(0.0) { $0 + $1.totalPrice }
        return "\(sum)"
    }
}

extension SummaryViewModel {
    var summaryItems: [ItemModel] {
        delegate?.reloadData()
        return items
    }
}
