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
    private let session: ProductSessionProtocol
    private let manager: DataManagerProtocol
    
    init(session: ProductSessionProtocol, manager: DataManagerProtocol) {
        self.session = session
        self.manager = manager
    }
    
    private(set) var lists: Results<ListModel>? {
        didSet {
            delegate?.reloadData()
        }
    }
    
    func readData() {
        manager.readData(data: ListModel.self) { result, error in
            if let error = error {
                print("Error reading data: \(error.localizedDescription)")
            } else if let result = result {
                self.lists = result
            }
        }
    }
    
    func updateListId(id: String) {
        session.updateListId(id: id)
    }
    
    func deleteItem(index: Int) {
        guard let item = lists?[index] else { return }
        manager.delete(data: item) { error in
            if let error {
                print("Error deleting item \(error.localizedDescription)")
            }
        }
    }
}
