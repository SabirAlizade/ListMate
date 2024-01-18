//
//  Items.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import Foundation
import RealmSwift

enum Measures: String, PersistableEnum {
    case pcs = "Pcs"
    case kgs = "Kgs"
    case l = "L"
}

class ItemModel: Object {
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var amount: Double
    @Persisted var measure: Measures
    @Persisted var price: Double
    @Persisted var totalPrice: Double
    @Persisted var image: String? // RENAME TO imagePath?
    @Persisted var boughtAt: String
    @Persisted var isBought: Bool
    @Persisted var notes: String
    
    convenience init(id: String,
                     name: String,
                     amount: Double,
                     image: String?,
                     measure: Measures,
                     price: Double,
                     totalPrice: Double = 0,
                     boughtAt: String = "",
                     isBought: Bool = false,
                     notes: String = "") {
        
        self.init()
        self.objectId = ObjectId.generate()
        self.id = id
        self.name = name
        self.image = image
        self.amount = amount
        self.measure = measure
        self.price = price
        self.totalPrice = totalPrice
        self.boughtAt = boughtAt
        self.isBought = isBought
        self.notes = notes
    }
}


