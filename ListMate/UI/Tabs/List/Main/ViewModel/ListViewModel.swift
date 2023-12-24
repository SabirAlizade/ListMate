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
    private let session: ProductSession
    private let manager = DataManager()
    
    init(session: ProductSession) {
        self.session = session
    }
    
    private(set) var lists: Results<ListModel>? {
        didSet {
            delegate?.reloadData()
        }
    }
    
    func readData() {
        manager.readData(data: ListModel.self) { result in
            self.lists = result
        }
    }
    
    func updateListId(id: String) {
        session.updateListId(id: id)
    }
    
    func deleteItem(item: ListModel) {
        let listId = item.id
        guard let realmItem = manager.realm.object(ofType: ListModel.self, forPrimaryKey: listId) else { return }
        manager.delete(data: realmItem) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}
