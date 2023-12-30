//
//  ListModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import Foundation
import RealmSwift

class ListModel: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var totalItemQuantity: Int
    @Persisted var completedQuantity: Int
    @Persisted var date: Date
    @Persisted var items = List<ItemModel>()
    @Persisted var totalAmount: Double
    
    convenience init(name: String,
                     toBuyQuantity: Int = 0,
                     remainsQuantity: Int = 0,
                     date: Date,
                     items: List<ItemModel>?,
                     totalAmount: Double) {
        
        self.init()
        self.id = id
        self.name = name
        self.totalItemQuantity = toBuyQuantity
        self.completedQuantity = remainsQuantity
        self.date = date
        self.items = items ?? List<ItemModel>()
        self.totalAmount = totalAmount
    }
}
