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

final class NewListViewModel {
    weak var delegate: NewListViewModelDelegate?
    
    private var manager = DataManager()
    private var lists: Results<ListModel>?
    private let session: ProductSession
    
    init(session: ProductSession, manager: DataManager = DataManager()) {
        self.session = session
        self.manager = manager
    }
    
    func saveListItem(name: String) {
        let list = ListModel(name: name,
                             date: Date.now,
                             items: List<ItemModel>(),
                             totalAmount: 0)
        manager.saveObject(data: list) { error in
            if let error {
                print("Error saving list item: \(error.localizedDescription)")
            }
            self.delegate?.reloadData()
        }
    }
}
