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
    
    private var lists: Results<ListModel>?
    
    private(set) var items: Results<ItemModel>? {
        didSet {
            delegate?.reloadData()
        }
    }
        
    var updateSummaryButton: ((Double) -> Void)?
    
    private var itemAmount: Double?
    private var selectedMeasure: Measures?
    
    func filter() {
        manager.filterID(id: session.listID) { result in
            self.items = result
            self.calculateSummary()
        }
    }
    
    //MARK: - DATABASE HANDLING
    func updateCheckmark(index: Int, isCheked: Bool) {
        guard let item = items?[index] else { return }
        do {
            try manager.realm.write {
                item.isBought = isCheked
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func updateAmount(index: Int, amount: Double) {
        guard let item = items?[index] else { return }
        let totalPrice = item.price * amount
        
        do {
            try manager.realm.write {
                item.amount = amount
                item.totalPrice = totalPrice
            }
        }
        catch {
            print(error.localizedDescription)
        }
        self.calculateSummary()
    }
    
    func deleteItem(item: ItemModel) {
        let itemId = item.objectId
        guard let realmItem = manager.realm.object(ofType: ItemModel.self, forPrimaryKey: itemId) else { return }
        manager.delete(data: realmItem) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
        self.filter()
    }
}

extension ItemsViewModel {
    
    func calculateSummary() {
        guard let items else { return }
        let sum = items.reduce(0.0) { $0 + $1.totalPrice}
        updateSummaryButton?(sum)
        updateListSummary(summary: sum)
    }
    
    func updateListSummary(summary: Double) {
        guard let uuid = UUID(uuidString: session.listID) else { return }
        if let list = manager.realm.objects(ListModel.self).filter("id == %@", uuid).first {
            do {
                try manager.realm.write {
                    list.totalAmount = summary
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}


