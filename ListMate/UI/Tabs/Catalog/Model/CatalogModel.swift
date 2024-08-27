//
//  HistoryModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 28.12.23.
//

import Foundation
import RealmSwift


class CatalogModel: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var price: Decimal128
    @Persisted var measure: Measures
    
    convenience init(
        name: String,
        price: Decimal128,
        measure: Measures
    ) {
        self.init()
        self.id = id
        self.name = name
        self.price = price
        self.measure = measure
    }
}
