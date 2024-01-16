//
//  SummaryViewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 28.12.23.
//

import Foundation


final class SummaryViewModel {
    
    private var items: [ItemModel] = []
    
    func updateItems(items: [ItemModel]) {
        self.items = items
    }
    
    func countTotal() -> String {
        let sum = items.reduce(0.0) { $0 + $1.totalPrice }
        return Double.doubleToString(double: sum)
    }
}

extension SummaryViewModel {
    var summaryItems: [ItemModel] {
        return items
    }
}
