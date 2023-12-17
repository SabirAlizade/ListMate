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
    case g = "g"
    case l = "L"
}

class ItemsModel: Object {
    @Persisted var name: String
    @Persisted var amount: Int
    @Persisted var measure: Measures
    @Persisted var price: Double
    @Persisted var category = List<CategoriesModel>()
    @Persisted var lastPrice: Double
    @Persisted var boughtAt: String
    @Persisted var date: Date
    @Persisted var isBought: Bool
    @Persisted var notes: String
    
    convenience init(name: String,
         amount: Int,
         measure: Measures,
         price: Double,
         category: List<CategoriesModel>?,
         lastPrice: Double,
         boughtAt: String,
         date: Date,
         isBought: Bool,
         notes: String) {
        
        self.init()
        self.name = name
        self.amount = amount
        self.measure = measure
        self.price = price
        self.category = category ?? List<CategoriesModel>()
        self.lastPrice = lastPrice
        self.boughtAt = boughtAt
        self.date = date
        self.isBought = isBought
        self.notes = notes
    }
}

class CategoriesModel: Object {
    @Persisted var name: String
    @Persisted var icon: String
    
    convenience init(name: String, icon: String) {
        self.init()
        self.name = name
        self.icon = icon
    }
}

