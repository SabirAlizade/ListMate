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
    private var summaryAmount: Double = 0
    
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
    
    func filter() {
        manager.filterID(id: session.listID) { result in
            self.items = result
        }
    }
    
    //    func updateSummary(summary: Double) {
    ////        var summaryArray: [Double] = []
    //    }
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
                item.totalprice = totalPrice
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    //        guard let item = items?[index] else { return }
    //
    //        //        item.amount = amount
    //        //        item.price *= amount
    //       // item.isBought = isCheked
    //
    //        manager.updateObject(data: item) { error in
    //            item.isBought = isCheked
    //
    //
    //            if let error {
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
    
    
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

extension ItemsViewModel {
    
    var summary: Double {
        guard !(items?.isEmpty ?? true) else {// MARK: IT CANT SEES THAT IT IS NOT EMPTY
            return 10
        }
        return items?.reduce(0) { $0 + $1.price } ?? 0
    }
}
