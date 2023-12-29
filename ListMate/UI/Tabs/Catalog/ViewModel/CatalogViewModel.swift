//
//  CatalogViewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 29.12.23.
//

import Foundation
import RealmSwift

protocol CatalogViewDelegate: AnyObject {
        func reloadData()
}

final class CatalogViewModel {
    
    weak var delegate: CatalogViewDelegate?
    
    private let manager = DataManager()

    private(set) var catalogItems: Results<CatalogModel>? {
        didSet {
            delegate?.reloadData()
        }
    }
    
    func readData() {
        manager.readData(data: CatalogModel.self) { result in
            self.catalogItems = result
        }
    }
    
    func deleteItem(item: CatalogModel) {
        let catalogId = item.id
        guard let realmItem = manager.realm.object(ofType: CatalogModel.self, forPrimaryKey: catalogId) else { return }
        manager.delete(data: realmItem) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
}
