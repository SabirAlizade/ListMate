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
    
    func deleteItem(index: Int) {
        guard let item = catalogItems?[index] else { return }
        manager.delete(data: item) { error in
            if let error {
                print("Error deleting catalog item \(error.localizedDescription)")
            }
        }
    }
}
