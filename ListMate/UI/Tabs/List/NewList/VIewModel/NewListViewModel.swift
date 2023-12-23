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
    private var lists: Results<ListModel>?
    
    func saveListItem(name: String) {
        let list = ListModel(name: name,
                             date: Date.now,
                             items: List<ItemModel>(),
                             totalAmount: 0)
        manager.saveObject(data: list) {  error in
            if let err = error {
                print(err.localizedDescription)
            }
        }
//            }       manager.saveObject(data: list) { result in
//            switch result {
//            case .success(let success):
//                self.delegate?.reloadData()
//                self.lists = success
//            case .failure(let failure):
//                print(failure.localizedDescription)
//            }
//        }
    }
}
