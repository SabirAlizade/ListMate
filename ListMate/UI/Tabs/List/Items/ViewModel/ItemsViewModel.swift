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
    func reloadListData()
}

class ItemsViewModel {
    
    weak var delegate: ItemsModelDelegate?
    
    private let manager = DataManager()
    private let session: ProductSession
    private var itemAmount: Double?
    private var selectedMeasure: Measures?
     var localItems: [ItemModel] = []
    
    init(session: ProductSession) {
        self.session = session
    }
    
    private(set) var items: Results<ItemModel>? {
        didSet {
          //  delegate?.reloadData()
        }
    }
    
    var updateSummaryButton: ((Double?) -> Void)?
    
    private func loadLocalItems() {
        guard let items = self.items else { return }
        self.localItems = Array(items)
        delegate?.reloadData()
    }
    
    private var remainsSection: [ItemModel] {
        return localItems.filter { !$0.isBought }
    }
    
    var completedSection: [ItemModel] {
        return localItems.filter { $0.isBought }
    }
    
    func filter() {
        manager.filterID(id: session.listID) { [self] result in
            self.localItems.removeAll()
            self.items = result
           
           
            self.loadLocalItems()
//            localItems.append(contentsOf: completedSection)
//            localItems.append(contentsOf: remainsSection)
        }
    }
    //MARK: - SECTIONS HANDLING
    
    func numberOfSections() -> Int {
        var numberOfSections = 1
        
        if !remainsSection.isEmpty {
            numberOfSections += 1
        }
        if !completedSection.isEmpty {
            numberOfSections += 1
        }
        return numberOfSections
    }
    
    func titleForSection(_ section: Int) -> String {
        return (section == 0 && !remainsSection.isEmpty) ? "Remains \(calcSectionPrice(section: remainsSection))" :
        (section == 1 && !completedSection.isEmpty) ? "Completed \(calcSectionPrice(section: completedSection))" : "No data"
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return (section == 0 && !remainsSection.isEmpty) ? remainsSection.count :
        (section == 1 && !completedSection.isEmpty) ? completedSection.count : 0
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> ItemModel? {
        return (indexPath.section == 0 && !remainsSection.isEmpty) ? remainsSection[indexPath.row] :
        (indexPath.section == 1 && !completedSection.isEmpty) ? completedSection[indexPath.row] : nil
    }
    
    private func calcSectionPrice(section: [ItemModel]) -> String {
        if !section.isEmpty {
            let sectionTotal = section.reduce(0) { $0 + $1.totalPrice}
            let formatString = Double.doubleToString(double: sectionTotal)
            if section == completedSection {
                if let unwrappedClosure = updateSummaryButton {
                    unwrappedClosure(sectionTotal)
                } else {
                    print("Error")
                }
            }
            return "Total: \(formatString) $"
        }
        return "Total: 0.0 $"
    }
    
    //MARK: - DATABASE HANDLING
    func updateCheckmark( isCheked: Bool, id: ObjectId) {
        
        if let item = localItems.first(where: { $0.objectId == id }) {
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
        
    
        filter()
        updateListSummary()
    }

    func updateAmount(amount: Double, id: ObjectId) {
        if let item = localItems.first(where: { $0.objectId == id }) {
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
    
    func deleteItem(item: ItemModel) {
        let itemId = item.objectId
        guard let realmItem = manager.realm.object(ofType: ItemModel.self,
                                                   forPrimaryKey: itemId) else { return }
        
        manager.delete(data: realmItem) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
     //   self.filter()
    }
}

extension ItemsViewModel {
    
    func updateListSummary() {
        guard let items else { return }
        let summary = items.reduce(0) { $0 + $1.totalPrice}
        guard let uuid = UUID(uuidString: session.listID) else { return }
        if let list = manager.realm.objects(ListModel.self).filter("id == %@", uuid).first {
            do {
                try manager.realm.write {
                    list.totalAmount = summary
                    list.completedQuantity = completedSection.count
                    list.totalItemQuantity = remainsSection.count + completedSection.count
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        print(completedSection.count)
        print(remainsSection.count + completedSection.count)
        delegate?.reloadListData()
    }
}

extension ItemsModelDelegate {
    func reloadListData() {}
}
