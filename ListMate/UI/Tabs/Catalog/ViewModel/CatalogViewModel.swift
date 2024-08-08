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
            MockCatalogModel(name: LanguageBase.catalog(.milk).translate, price: 0, measure: .l),
            MockCatalogModel(name: LanguageBase.catalog(.bread).translate, price: 0, measure: .pcs),
            MockCatalogModel(name: LanguageBase.catalog(.butter).translate, price: 0, measure: .pcs),
            MockCatalogModel(name: LanguageBase.catalog(.bananas).translate, price: 0, measure: .kgs),
            MockCatalogModel(name: LanguageBase.catalog(.eggs).translate, price: 0, measure: .pcs),
            MockCatalogModel(name: LanguageBase.catalog(.potatoes).translate, price: 0, measure: .kgs),
            MockCatalogModel(name: LanguageBase.catalog(.tomatoes).translate, price: 0, measure: .kgs),
            MockCatalogModel(name: LanguageBase.catalog(.water).translate, price: 0, measure: .l),
            MockCatalogModel(name: LanguageBase.catalog(.orangeJuice).translate, price: 0, measure: .l),
            MockCatalogModel(name: LanguageBase.catalog(.chicken).translate, price: 0, measure: .pcs),
            MockCatalogModel(name: LanguageBase.catalog(.cheese).translate, price: 0, measure: .kgs),
            MockCatalogModel(name: LanguageBase.catalog(.apples).translate, price: 0, measure: .kgs),
            MockCatalogModel(name: LanguageBase.catalog(.yougurt).translate, price: 0, measure: .pcs),
            MockCatalogModel(name: LanguageBase.catalog(.pasta).translate, price: 0, measure: .pcs),
            MockCatalogModel(name: LanguageBase.catalog(.rice).translate, price: 0, measure: .kgs),
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

//    func readData() {
//        manager.readData(data: CatalogModel.self) { result in
//            self.catalogItems = result
//        }
//    }
//    
    
    func readData() {
        manager.readData(data: CatalogModel.self) { result, error in
            if let error = error {
                print("Error reading data: \(error.localizedDescription)")
                // Handle the error as needed
                self.catalogItems = nil
            } else if let result = result {
                self.catalogItems = result
            } else {
                self.catalogItems = nil
            }
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

extension CatalogViewModel {
    func clearMockData() {
        try? manager.realm.write {
                   manager.realm.delete(manager.realm.objects(CatalogModel.self))
               }
    }
}
