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

class ItemsModel: Object {
//    @Persisted(primaryKey: true) var id: UUID
    @Persisted var id: UUID
    @Persisted var name: String
    @Persisted var amount: Double
    @Persisted var measure: Measures
    @Persisted var price: Double
    @Persisted var image: String
    // @Persisted var category = List<CategoriesModel>()
    //@Persisted var lastPrice: Double
    @Persisted var boughtAt: String
    @Persisted var isBought: Bool
    @Persisted var notes: String
    
    convenience init(id: UUID,
                     name: String,
                     amount: Double,
                     image: String,
                     measure: Measures,
                     price: Double,
                     // category: List<CategoriesModel>?,
                     //  lastPrice: Double,
                     boughtAt: String = "",
                     isBought: Bool = false,
                     notes: String = "") {
        
        self.init()
        self.id = id
        self.name = name
        self.image = image
        self.amount = amount
        self.measure = measure
        self.price = price
        //  self.category = category ?? List<CategoriesModel>()
        //  self.lastPrice = lastPrice
        self.boughtAt = boughtAt
        self.isBought = isBought
        self.notes = notes
    }
}

//class CategoriesModel: Object {
//    @Persisted var name: String
//    @Persisted var icon: String
//
//    convenience init(name: String, icon: String) {
//        self.init()
//        self.name = name
//        self.icon = icon
//    }
//}

