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
    
    private(set) var items: Results<ItemModel>? {
        didSet {
            delegate?.reloadData()
        }
    }
    
    var updateSummaryButton: ((Double) -> Void)?
    
    private var itemAmount: Double?
    private var selectedMeasure: Measures?
    
    private var remainsSection: [ItemModel] {
        return items?.filter("isBought == false").compactMap { $0 } ?? []
    }
    private var completedSection: [ItemModel] {
        return items?.filter("isBought == true").compactMap { $0 } ?? []
    }
    
    var toBuySection: (name: String, items: [ItemModel], totalPrice: Double) {
        let filteredItems = items?.filter("isBought == false").compactMap { $0 } ?? []
        let total = filteredItems.reduce(0) { $0 + $1.price }
        return ("To buy", filteredItems, total)
    }
    
    func filter() {
        manager.filterID(id: session.listID) { result in
            self.items = result
            self.calculateSummary()
        }
    }
    //MARK: - SECTIONS HANDLING
    
    func numberOfSections() -> Int {
        var numberOfSections = 0
        
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
            let sectionTotal = section.reduce(0) { $0 + $1.price}
            let formatString = String(format: "%.1f", sectionTotal)
            return "Total: \(formatString) $"
        }
        return "Total: 0.0 $"
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
        filter()
        delegate?.reloadData()
        print(index)
        print(isCheked)
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
        guard let realmItem = manager.realm.object(ofType: ItemModel.self,
                                                   forPrimaryKey: itemId) else { return }
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


