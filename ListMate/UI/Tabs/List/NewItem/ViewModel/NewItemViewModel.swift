//
//  NewItemIVewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 20.12.23.
//

import Foundation
import RealmSwift

protocol NewItemDelegate: AnyObject {
    func updateItemsData()
}

protocol PassSuggestionDelegate: AnyObject {
    func passSuggested(name: String, price: Decimal128, measure: Measures)
    func updateSuggestionsData()
    func checkSuggestionsBar()
}

final class NewItemViewModel {
    
    weak var delegate: NewItemDelegate?
    weak var suggestionDelegate: PassSuggestionDelegate?
    
    var selectedMeasure: Measures = .pcs
    private var amountValue: Decimal128 = 1
    private let productSession: ProductSession
    private let manager = DataManager()
    
    var catalogItems: [CatalogModel] = []
    
    init(session: ProductSession) {
        self.productSession = session
    }
    
    func setAmount(amount: Decimal128) {
        amountValue = amount
    }
    
    // MARK: - Data Operations
    
    func saveItem(
        name: String,
        price: Decimal128,
        imagePath: String?,
        measure: Measures
    ) {
        let item = ItemModel(
            id: productSession.listID,
            name: name,
            amount: amountValue,
            imagePath: imagePath,
            measure: measure,
            price: price,
            totalPrice: price * amountValue
        )
        
        manager.saveObject(data: item) { error in
            if let error {
                print("Error saving item \(error.localizedDescription)")
            }
        }
        delegate?.updateItemsData()
        passToCatalog(name: name, price: price, measure: measure)
        NotificationCenter.default.post(name: Notification.Name("ReloadCatalogData"), object: nil)
    }
}

// MARK: - Catalog Data Operations

extension NewItemViewModel {
    private func passToCatalog(name: String, price: Decimal128, measure: Measures) {
        let catalogItem = CatalogModel(name: name, price: price, measure: measure)
        if let existingItem = manager.realm.objects(CatalogModel.self).filter("name == %@", name).first {
            updateCatalogItem(existingItem, with: catalogItem)
        } else {
            saveCatalogItem(catalogItem)
        }
    }
    
    private func saveCatalogItem(_ item: CatalogModel) {
        manager.saveObject(data: item) { error in
            if let error = error {
                print("Error saving to catalog \(error.localizedDescription)")
            }
        }
    }
    
    private func updateCatalogItem(_ existingItem: CatalogModel, with newItem: CatalogModel) {
        try? manager.realm.write {
            existingItem.price = newItem.price
        }
        NotificationCenter.default.post(name: Notification.Name("ReloadCatalogData"), object: nil)
    }
    
    func readCatalogData() {
        catalogItems.removeAll()
        manager.readData(data: CatalogModel.self) { [weak self] result, error in
            if let error = error {
                print("Error reading catalog data: \(error.localizedDescription)")
            } else if let result = result {
                self?.catalogItems.append(contentsOf: result)
            }
        }
    }
    
    func filterSuggestions(name: String) {
        if name.isEmpty {
            readCatalogData()
        } else {
            filterCatalogData(by: name)
            suggestionDelegate?.updateSuggestionsData()
        }
        checkCatalogCount()
    }
    
    private func filterCatalogData(by name: String) {
        let namePredicate = NSPredicate(format: "name CONTAINS[c] %@", name)
        manager.filterObjects(type: CatalogModel.self, predicate: namePredicate) { [weak self] result in
            guard let self else { return }
            self.catalogItems.removeAll()
            self.catalogItems.append(contentsOf: result)
        }
    }
    
    func passSuggestedItem(name: String, price: Decimal128, measure: Measures) {
        suggestionDelegate?.passSuggested(name: name, price: price, measure: measure)
        suggestionDelegate?.updateSuggestionsData()
        selectedMeasure = measure
    }
    
    func checkCatalogCount() {
        suggestionDelegate?.checkSuggestionsBar()
    }
}

