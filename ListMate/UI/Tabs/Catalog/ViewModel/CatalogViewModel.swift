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
    private let mockCatalogDataKey = "MockCatalogData"
    private var mockDeletedState: [String: Bool] = [:]
    private(set) var catalogItems: Results<CatalogModel>? {
        didSet {
            delegate?.reloadData()
        }
    }
    
    init() {
        loadDeletedState()
    }
    
    func loadMockData() {
        let mockData: [MockCatalogModel] = [
            MockCatalogModel(name: "Milk", price: 0, measure: .l),
            MockCatalogModel(name: "Bread", price: 0, measure: .pcs),
            MockCatalogModel(name: "Butter", price: 0, measure: .pcs),
            MockCatalogModel(name: "Bananas", price: 0, measure: .kgs),
            MockCatalogModel(name: "Eggs", price: 0, measure: .pcs),
            MockCatalogModel(name: "Potatoes", price: 0, measure: .kgs),
            MockCatalogModel(name: "Tomatoes", price: 0, measure: .kgs),
            MockCatalogModel(name: "Water", price: 0, measure: .l),
            MockCatalogModel(name: "Orance juice", price: 0, measure: .l),
            MockCatalogModel(name: "Chicken", price: 0, measure: .pcs),
            MockCatalogModel(name: "Cheese", price: 0, measure: .kgs),
            MockCatalogModel(name: "Apples", price: 0, measure: .kgs),
            MockCatalogModel(name: "Yougurt", price: 0, measure: .pcs),
            MockCatalogModel(name: "Pasta", price: 0, measure: .pcs),
            MockCatalogModel(name: "Rice", price: 0, measure: .kgs),
        ]
        
        for item in mockData {
            let existingItem = manager.realm.objects(CatalogModel.self).filter("name == %@", item.name).first
            if existingItem == nil && !(mockDeletedState[item.name] ?? false) {
                let catalogModel = CatalogModel()
                catalogModel.name = item.name
                catalogModel.price = item.price
                catalogModel.measure = item.measure
                
                manager.saveObject(data: catalogModel) { error in
                    if let error = error {
                        print("Error saving catalog item \(error.localizedDescription)")
                    }
                }
            }
        }
        readData()
    }

    func readData() {
        manager.readData(data: CatalogModel.self) { result in
            self.catalogItems = result
        }
    }
    
    func deleteItem(index: Int) {
        guard let item = catalogItems?[index] else { return }
        if !(mockDeletedState[item.name] ?? false) {
            mockDeletedState[item.name] = true
            saveDeletedState()
        }
        
        manager.delete(data: item) { error in
            if let error {
                print("Error deleting catalog item \(error.localizedDescription)")
            }
            self.readData()
        }
    }
    //MARK: - Mock data manage
    
    private func loadDeletedState() {
          if let storedState = UserDefaults.standard.dictionary(forKey: mockCatalogDataKey) as? [String: Bool] {
              mockDeletedState = storedState
          }
      }

      private func saveDeletedState() {
          UserDefaults.standard.set(mockDeletedState, forKey: mockCatalogDataKey)
      }
}
