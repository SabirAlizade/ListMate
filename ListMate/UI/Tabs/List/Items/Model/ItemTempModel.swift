//
//  ItemTempModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 08.01.24.

import Foundation
import RealmSwift

struct ItemSection {
    var name: String = ""
    var amount: Double = 0.0
    let data: [ItemModel]
}

struct ItemTempModel {
     var id: String
     var name: String
     var amount: Decimal128
     var measure: Measures
     var price: Decimal128
     var totalPrice: Decimal128
     var image: String?
     var boughtAt: String
     var isBought: Bool
     var notes: String
    
    init(item: ItemModel) {
        self.id = item.id
        self.name = item.name
        self.amount = item.amount
        self.measure = item.measure
        self.price = item.price
        self.totalPrice = item.totalPrice
        self.image = item.imagePath
        self.boughtAt = item.storeName
        self.isBought = item.isChecked
        self.notes = item.notes
    }
}
