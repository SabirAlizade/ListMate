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
}

final class ItemsViewModel {
    
    weak var delegate: ItemsModelDelegate?
    weak var quantityDelegate: ItemsQuantityDelegate?
    private let manager = DataManager()
    private let productSession: ProductSession
    private var itemAmount: Double?
    private var selectedMeasure: Measures?
    private var completedItemsQuantity: Int = 0
    private(set) var items: Results<ItemModel>?
    var updateSummaryButton: ((Decimal128) -> Void)?
    var completedItemsArray: [ItemModel] = []
    private var summaryAmount: Decimal128 = 0 {
        didSet {
            updateSummaryButton?(summaryAmount)
        }
    }
    
    init(session: ProductSession) {
        self.productSession = session
    }
    
    // MARK: - List Data
    
    func readFilteredData(completion: @escaping() -> Void) {
        manager.filterID(id: productSession.listID) { [weak self] result in
            guard let self else { return }
            self.items = result
            self.delegate?.reloadData()
            completion()
        }
    }
    
    func getSections() -> [ItemSection] {
        guard let items = items else { return [] }
        
        let remainingItems = items.filter { !$0.isChecked }
        let completedItems = items.filter { $0.isChecked }
        
        updateListSummary(completedItems: completedItems, remainingItems: remainingItems)
        
        completedItemsArray = Array(completedItems)
        
        return [
            ItemSection(name: LanguageBase.item(.remainingTotal).translate, data: Array(remainingItems)),
            ItemSection(name: LanguageBase.item(.completedTotal).translate, data: Array(completedItems))
        ]
    }
    
    func sectionHeaderTitle(for section: Int) -> String {
        let sectionModel = getSections()[section]
        guard !sectionModel.data.isEmpty else { return "" }
        
        let sectionTotal = sectionModel.data.reduce(0, { $0 + $1.totalPrice })
        return "\(sectionModel.name) \(Double.doubleToString(double: sectionTotal.doubleValue)) \(LanguageBase.system(.currency).translate)"
    }
    
    // MARK: - Data Operations
    
    func updateCheckmark(isChecked: Bool, id: ObjectId) {
        guard let item = items?.first(where: { $0.objectId == id }) else { return }
        performRealmWrite {
            item.isChecked = isChecked
        }
        delegate?.reloadData()
    }
    
    func updateAmount(amount: Decimal128, id: ObjectId) {
        guard let item = items?.first(where: { $0.objectId == id }) else { return }
        let totalPrice = item.price * amount
        performRealmWrite {
            item.amount = amount
            item.totalPrice = totalPrice
        }
        delegate?.reloadData()
    }
    
    func removeRow(indexPath: IndexPath) {
        let sectionItems = getSections()[indexPath.section].data
        
        guard indexPath.row < sectionItems.count else {
            print("Invalid index for deletion")
            return
        }
        
        let item = sectionItems[indexPath.row]
        manager.delete(data: item) { error in
            if let error {
                print("Failed to delete item: \(error.localizedDescription)")
            }
        }
        delegate?.reloadData()
    }
    
    private func updateListSummary(completedItems: LazyFilterSequence<Results<ItemModel>>, remainingItems: LazyFilterSequence<Results<ItemModel>>) {
        summaryAmount = completedItems.reduce(0) { $0 + $1.totalPrice }
        
        guard let listUUID = UUID(uuidString: productSession.listID) else { return }
        guard let list = manager.realm.objects(ListModel.self).filter("id == %@", listUUID).first else { return }
        
        performRealmWrite {
            list.totalAmount = summaryAmount
            list.completedQuantity = completedItems.count
            list.totalItemQuantity = completedItems.count + remainingItems.count
        }
        quantityDelegate?.updateQuantity()
    }
    
    private func performRealmWrite(_ block: () -> Void) {
        do {
            try manager.realm.write {
                block()
            }
        } catch {
            print("Realm write error: \(error.localizedDescription)")
        }
    }
}
