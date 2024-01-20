//
//  NewItemIVewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 20.12.23.
//

import Foundation
import RealmSwift
import UIKit

protocol NewItemDelegate: AnyObject {
    func updateItemsData()
}

protocol PassSuggestionDelegate: AnyObject {
    func passSuggested(name: String, price: Double, measure: Measures)
}

final class NewItemViewModel {
    
    weak var delegate: NewItemDelegate?
    weak var suggestionDelegate: PassSuggestionDelegate?
    
    var measuresArray: [String] = ["Pcs", "Kgs", "L"] //MARK: DELETE THIS AND USE HASH
    
    var selectedMeasure: Measures = .pcs
    private var amountValue: Double = 1
    var item: Results<ItemModel>?
    
    private let session: ProductSession
    
    var catalogItems: [CatalogModel] = []
    
    init(session: ProductSession) {
        self.session = session
    }
    
    private let manager = DataManager()
    
    func saveItem(name: String,
                  price: Double,
                  imagePath: String?,
                  measure: Measures) {
        
        let item = ItemModel(id: session.listID,
                             name: name,
                             amount: amountValue,
                             image: imagePath,
                             measure: measure,
                             price: price,
                             totalPrice: price)
        
        manager.saveObject(data: item) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
        delegate?.updateItemsData()
        passToCatalog(name: name, price: price, measure: measure)
    }
    
    func setAmount(amount: Double) {
        amountValue = amount
    }
    
    func passSuggestedItem(name: String, price: Double, measure: Measures) {
        suggestionDelegate?.passSuggested(name: name, price: price, measure: measure)
    }
}

extension NewItemViewModel {
    private func passToCatalog(name: String, price: Double, measure: Measures) {
        let catalogItem = CatalogModel(name: name, price: price, measure: measure)
        if manager.realm.objects(CatalogModel.self).filter("name == %@", name).first != nil {
            print("Item already exist")
            return
        } else {
            self.manager.saveObject(data: catalogItem) { error in
                if let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func readData() {
        manager.readData(data: CatalogModel.self) { result in
            self.catalogItems.append(contentsOf: result )
        }
    }
    
    func filter(name: String) {
        let namePredicate = NSPredicate(format: "name CONTAINS[c] %@", name)
        manager.filterObjects(type: CatalogModel.self, predicate: namePredicate) { result in
            self.catalogItems.append(contentsOf: result )
        }
    }
}
