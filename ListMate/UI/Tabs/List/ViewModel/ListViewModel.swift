//
//  ListViewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import Foundation
import RealmSwift

protocol ListViewModelDelegate: AnyObject {
    func reloadData()
}

final class ListViewModel {
    weak var delegate: ListViewModelDelegate?
    
    private let manager = DataManager()
    
    private(set) var lists: Results<ListModel>? {
        didSet {
            delegate?.reloadData()
        }
    }
    
    func saveListItem(name: String,
                      toBuy: Int,
                      remains: Int,
                      date: Date,
                      totalAmount: Double) {
        
        let list = ListModel(name: name,
                             toBuyQuantity: toBuy,
                             remainsQuantity: remains,
                             date: date,
                             items: List<ItemsModel>(),
                             totalAmount: totalAmount)
        manager.saveObject(data: list) { result in
            switch result {
            case .success(let success):
                self.lists = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        delegate?.reloadData()
    }
    
    func readData() {
        manager.readData(data: ListModel.self) { result in
            self.lists = result
        }
    }
}
