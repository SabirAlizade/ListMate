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
    
    var completedItemsArray: [ItemModel] = []
    
    private var summaryAmount: Decimal128 = 0 {
        didSet {
            updateSummaryButton?(summaryAmount)
        }
    }
    
    var updateSummaryButton: ((Decimal128) -> Void)?
    
    private var completedItemsQuantity: Int = 0
    
    private(set) var items: Results<ItemModel>?
    
    init(session: ProductSession) {
        self.productSession = session
    }
    
    func readFilteredData(completion: @escaping() -> Void) {
        manager.filterID(id: productSession.listID) { [weak self] result in
            guard let self else { return }
            self.items = result
            self.delegate?.reloadData()
            completion()
        }
    }
    
    func getSections() -> [ItemSection] {
        guard let items else { return [] }
        
        let remainingItems = items.filter { !$0.isChecked }
        let completedItems = items.filter { $0.isChecked }
        let remainingSection = ItemSection(name: LanguageBase.item(.remainingTotal).translate,
                                           data: Array(remainingItems))
        let completedSection = ItemSection(name: LanguageBase.item(.completedTotal).translate,
                                           data: Array(completedItems))
        
        updateListSummary(completedItems: completedItems, remainItems: remainingItems)
        
        completedItemsArray.removeAll()
        completedItemsArray.append(contentsOf: completedItems)
        return [remainingSection, completedSection]
    }
    
    func sectionHeaderTitle(for section: Int) -> String {
        let sectionModel = getSections()[section]
        
        if sectionModel.data.isEmpty {
            return ""
        } else {
            let sectionTotal = sectionModel.data.reduce(0, { $0 + $1.totalPrice })
            return "\(sectionModel.name) \(Double.doubleToString(double: sectionTotal.doubleValue)) \(LanguageBase.system(.currency).translate)"
        }
    }
    
    func updateCheckmark(isCheked: Bool, id: ObjectId) {
        if let item = items?.first(where: { $0.objectId == id }) {
            do {
                try manager.realm.write {
                    item.isChecked = isCheked
                }
            }
            catch {
                print("Failed to update checkmark: \(error.localizedDescription)")
            }
            delegate?.reloadData()
        }
    }
    
    func updateAmount(amount: Decimal128, id: ObjectId) {
        if let item = items?.first(where: { $0.objectId == id }) {
            let totalPrice = item.price * amount
            do {
                try manager.realm.write {
                    item.amount = amount
                    item.totalPrice = totalPrice
                }
            }
            catch {
                print("Failed to update amount: \(error.localizedDescription)")
            }
            delegate?.reloadData()
        }
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
        self.delegate?.reloadData()
    }
}

extension ItemsViewModel {
    
    func updateListSummary(completedItems: LazyFilterSequence<Results<ItemModel>>, remainItems: LazyFilterSequence<Results<ItemModel>>) {
        let summary = completedItems.reduce(0) { $0 + $1.totalPrice}
        
        summaryAmount = summary
        
        guard let listUUID = UUID(uuidString: productSession.listID) else { return }
        if let list = manager.realm.objects(ListModel.self).filter("id == %@", listUUID).first {
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
        quantityDelegate?.updateQuantity()
    }
}
