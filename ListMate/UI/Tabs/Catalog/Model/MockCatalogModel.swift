//
//  MockCatalogModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 06.02.24.
//

import Foundation
import RealmSwift

struct MockCatalogModel: Codable {
    let name: String
    let price: Decimal128
    let measure: Measures
    
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case measure
    }
}
