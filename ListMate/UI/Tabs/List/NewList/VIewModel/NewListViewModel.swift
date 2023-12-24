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
    private let session: ProductSession
    
    init(session: ProductSession) {
        self.session = session
    }
    
    func saveListItem(name: String) {
        let list = ListModel(name: name,
                             date: Date.now,
                             items: List<ItemModel>(),
                             totalAmount: 0)
        manager.saveObject(data: list) {  error in
            if let err = error {
                print(err.localizedDescription)
            }
            self.delegate?.reloadData()
        }
    }
}
