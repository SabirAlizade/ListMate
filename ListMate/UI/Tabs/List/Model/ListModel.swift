//
//  ListModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import Foundation
import RealmSwift

class ListModel: Object {
    @Persisted var name: String
    @Persisted var toBuyQuantity: Int
    @Persisted var remainsQuantity: Int
    @Persisted var date: Date
    @Persisted var items = List<ItemsModel>()
    @Persisted var totalAmount: Double
    
    convenience init(name: String,
                     toBuyQuantity: Int,
                     remainsQuantity: Int,
                     date: Date,
                     items: List<ItemsModel>?,
                     totalAmount: Double) {
        
        self.init()
        self.name = name
        self.toBuyQuantity = toBuyQuantity
        self.remainsQuantity = remainsQuantity
        self.date = date
        self.items = items ?? List<ItemsModel>()
        self.totalAmount = totalAmount
    }
}
