//
//  ItemsVIewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import Foundation
import RealmSwift

//protocol ItemsModelDelegate: AnyObject {
//    func reloadData()
//}

class ItemsViewModel {
    
    private let manager = DataManager()
    
//    weak var delegate: ItemsModelDelegate?
    
    private(set) var items: Results<ItemModel>? {
        didSet {
         //   delegate?.reloadData()
        }
    }
    
    var itemsArray: [ItemModel] = []
    
    private var itemAmount: Double?
    private var selectedMeasure: Measures?
    
    func minusButtonAction() {}
    
    func plusButtonAction() {}
}
    
extension ItemsViewModel {
    
    func readData() {
        manager.readData(data: ItemModel.self) { result in
            self.items = result
            self.itemsArray = Array(result)
            print(result)
        }
    }
    
    func deleteItem(item: ItemModel) {
        guard let realmItem = manager.realm.object(ofType: ItemModel.self, forPrimaryKey: ItemModel.primaryKey()) else { return }
        
            manager.delete(data: realmItem) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }

}
