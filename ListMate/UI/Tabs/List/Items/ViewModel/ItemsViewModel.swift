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
    
    private let manager = DataManager()
    
    weak var delegate: ItemsModelDelegate?

    private(set) var items: Results<ItemsModel>? {
        didSet {
            delegate?.reloadData()
        }
    }
    
    private var itemAmount: Double?
    private var selectedMeasure: Measures?
    
    func setAmount() {
        
    }
    
    func saveItems(name: String, amount: Double, image: String = "noImage", measure: Measures, price: Double, isBought: Bool = false) {
        
        let item = ItemsModel(id: UUID(), name: name,
                              amount: amount,
                              image: image,
                              measure: measure,
                              price: price,
                              isBought: isBought)
        
        manager.saveObject(data: item) { result in
            switch result {
            case .success(let success):
                self.items = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
             delegate?.reloadData()
    }
    
    func readData() {
        manager.readData(data: ItemsModel.self) { result in
            self.items = result
        }
    }
    
}
