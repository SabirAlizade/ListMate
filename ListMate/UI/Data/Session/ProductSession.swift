//
//  ProductSession.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import Foundation

final class ProductSession {
    
    static let shared = ProductSession()
    private init() {}
    
    private var lock = NSLock()
    private(set) var listID: String = ""
    
    func updateListId(id: String) {
        lock.lock()
        defer { lock.unlock() }
        listID = id
    }
}

protocol ProductSessionProtocol {
    var listID: String { get }
    func updateListId(id: String)
}

extension ProductSession: ProductSessionProtocol {}

