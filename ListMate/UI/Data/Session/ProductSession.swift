//
//  ProductSession.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import Foundation

class ProductSession {
    
    static let shared = ProductSession()
    private init() {}
    
    private(set) var listID: String = ""
    
    func updateListId(id: String) {
        listID = id
    }
}

protocol ProductSessionProtocol {
    var listID: String { get }
    func updateListId(id: String)
}

extension ProductSession: ProductSessionProtocol { }

