//
//  ItemsVIewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import Foundation
import RealmSwift

protocol ItemsModelDelegate: AnyObject {
    func reloadData()
}

class ItemsViewModel {
    weak var delegate: ItemsModelDelegate?
    private let manager = DataManager()
    private let session: ProductSession
    
    init(session: ProductSession) {
        self.session = session
    }
    
    private(set) var items: Results<ItemModel>? {
        didSet {
            delegate?.reloadData()
        }
    }
    
    private var itemAmount: Double?
    private var selectedMeasure: Measures?
    
    func minusButtonAction() {}
    func plusButtonAction() {}
    
    func filter() {
        manager.filterID(id: session.listID) { result in
            self.items = result
            print(result ?? "RESULT ERROR")
        }
    }
}

extension ItemsViewModel {
    
    func deleteItem(item: ItemModel) {
        let itemId = item.objectId
        guard let realmItem = manager.realm.object(ofType: ItemModel.self, forPrimaryKey: itemId) else { return }
        manager.delete(data: realmItem) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}
