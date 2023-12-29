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
    @Persisted var price: Double
    
    convenience init(name: String,
                     price: Double) {
        
        self.init()
        self.id = id
        self.name = name
        self.price = price
    }
}
