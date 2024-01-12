//
//  ItemsVIewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import Foundation
import RealmSwift

protocol ItemsQuantityDelegate: AnyObject {
    func updateQuantity()
}

protocol ItemsModelDelegate: AnyObject {
    func reloadData()
    //    func reloadListData()
}

class ItemsViewModel {
    
    weak var delegate: ItemsModelDelegate?
    weak var quantityDelegate: ItemsQuantityDelegate?
    
    private let manager = DataManager()
    private let session: ProductSession
    private var itemAmount: Double?
    private var selectedMeasure: Measures?
    
    var completedItemsArray: [ItemModel] = []
    
    private var summaryAmount: Double = 0 {
        didSet {
            updateSummaryButton?(summaryAmount)
        }
    }
    
    var updateSummaryButton: ((Double) -> Void)?
    
    private var completedItemsQuantity: Int = 0
    
    private(set) var items: Results<ItemModel>?
    
    init(session: ProductSession) {
        self.session = session
    }
    
    func readFilteredData() {
        manager.filterID(id: session.listID) { [self] result in
            self.items = result
            self.delegate?.reloadData()
        }
    }
    
    //   updateListSummary()
    
    func getSections() -> [ItemSection] {
        guard let items else { return [] }
        let completedItems = items.filter { $0.isBought }
        let remainsItems = items.filter { !$0.isBought }
        
        let completedSection = ItemSection(name: "Completed", data: Array(completedItems))
        let remainsSection = ItemSection(name: "Remains", data: Array(remainsItems))
        
        updateListSummary(completedItems: completedItems, remainItems: remainsItems)
        
        completedItemsArray.removeAll()
        completedItemsArray.append(contentsOf: completedItems)
        return [completedSection, remainsSection]
    }
    
    func sectionHeaderTitle(for section: Int) -> String {
        let sectionModel = getSections()[section]
        let sectionTotal = sectionModel.data.reduce(0, { $0 + $1.totalPrice })
        let formatString = Double.doubleToString(double: sectionTotal)
        return "\(sectionModel.name) total: \(formatString) $"
    }
    
    func updateCheckmark(isCheked: Bool, id: ObjectId) {
        if let item = items?.first(where: { $0.objectId == id }) {
            do {
                try manager.realm.write {
                    item.isBought = isCheked
                }
            }
            catch {
                print(error.localizedDescription)
            }
            delegate?.reloadData()
        }
        // readFilteredData()
    }
    
    func updateAmount(amount: Double, id: ObjectId) {
        if let item = items?.first(where: { $0.objectId == id }) {
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
            delegate?.reloadData()
        }
    }
    
    func removeRow(index: Int) {
        guard let item = items?[index] else { return }
        manager.delete(data: item) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}

extension ItemsViewModel {
    
    func updateListSummary(completedItems: LazyFilterSequence<Results<ItemModel>>, remainItems: LazyFilterSequence<Results<ItemModel>>) {
        let summary = completedItems.reduce(0) { $0 + $1.totalPrice}
        
        summaryAmount = summary
        
        guard let uuid = UUID(uuidString: session.listID) else { return }
        if let list = manager.realm.objects(ListModel.self).filter("id == %@", uuid).first {
            do {
                try manager.realm.write {
                    list.totalAmount = summary
                    list.completedQuantity = completedItems.count
                    list.totalItemQuantity = completedItems.count + remainItems.count
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        //delegate?.reloadListData()
        quantityDelegate?.updateQuantity()
    }
}
