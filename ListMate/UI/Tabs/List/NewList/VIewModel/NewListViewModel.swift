//
//  NewListViewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import Foundation
import RealmSwift


protocol NewListViewModelDelegate: AnyObject {
    func reloadData()
}

class NewListViewModel {
    
    weak var delegate: NewListViewModelDelegate?
    
    private let manager = DataManager()
    
    var lists: Results<ListModel>?
    
    func saveListItem(name: String) {
        let list = ListModel(name: name,
                             date: Date.now,
                             items: List<ItemsModel>(),
                             totalAmount: 0)
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
}
