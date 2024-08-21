//
//  Items.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import Foundation
import RealmSwift

enum Measures: String, PersistableEnum, Codable {
    case pcs = "Pcs"
    case kgs = "Kgs"
    case l = "L"
    
    var translate: String {
        switch self {
        case .pcs:
            return MeasureLanguage.pcs.translate
        case .kgs:
            return MeasureLanguage.kgs.translate
        case .l:
            return MeasureLanguage.l.translate
        }
    }
}

class ItemModel: Object {
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var amount: Decimal128
    @Persisted var measure: Measures
    @Persisted var price: Decimal128
    @Persisted var totalPrice: Decimal128
    @Persisted var imagePath: String?
    @Persisted var storeName: String
    @Persisted var isChecked: Bool
    @Persisted var notes: String
    
    convenience init(
        id: String,
        name: String,
        amount: Decimal128,
        imagePath: String?,
        measure: Measures,
        price: Decimal128,
        totalPrice: Decimal128 = 0,
        boughtAt: String = "",
        isBought: Bool = false,
        notes: String = ""
    ) {
        self.init()
        self.objectId = ObjectId.generate()
        self.id = id
        self.name = name
        self.imagePath = imagePath
        self.amount = amount
        self.measure = measure
        self.price = price
        self.totalPrice = totalPrice
        self.storeName = boughtAt
        self.isChecked = isBought
        self.notes = notes
    }
}


