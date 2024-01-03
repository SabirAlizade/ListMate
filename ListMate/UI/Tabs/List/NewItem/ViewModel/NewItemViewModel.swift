//
//  NewItemIVewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 20.12.23.
//

import Foundation
import RealmSwift

protocol NewItemDelegate: AnyObject {
    func reloadAndFilterData()
    func passSuggested(name: String, price: Double, measure: Measures)
}

final class NewItemViewModel {
    weak var delegate: NewItemDelegate?
    
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
                  image: String,
                  measure: Measures) {
        
        let item = ItemModel(id: session.listID,
                             name: name,
                             amount: amountValue,
                             image: image,
                             measure: measure,
                             price: price,
                             totalPrice: price)
        
        manager.saveObject(data: item) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
        delegate?.reloadAndFilterData()
        passToCatalog(name: name, price: price, measure: measure)
    }
    
    func setAmount(amount: Double) {
        amountValue = amount
    }
}

extension NewItemViewModel {
    
    private func passToCatalog(name: String, price: Double, measure: Measures) {
        let catalogItem = CatalogModel(name: name, price: price, measure: measure)
        manager.saveObject(data: catalogItem) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func readData() {
        manager.readData(data: CatalogModel.self) { result in
            self.catalogItems.append(contentsOf: result )
        }
    }
    
    func passSuggestedItem(name: String, price: Double, measure: Measures) {
        delegate?.passSuggested(name: name, price: price, measure: measure)
    }
    
    func filter(name: String) {
        let namePredicate = NSPredicate(format: "name CONTAINS[c] %@", name)
        manager.filterObjects(type: CatalogModel.self, predicate: namePredicate) { result in
            self.catalogItems.append(contentsOf: result )
            print(result)
        }
    }
}
extension NewItemDelegate {
    func passSuggested(name: String, price: Double, measure: Measures) {}
    func reloadAndFilterData() {}
}
