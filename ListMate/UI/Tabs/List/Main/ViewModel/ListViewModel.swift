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
    func showError(_ message: String)
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
        manager.readData(data: ListModel.self) { [weak self] result, error in
            guard let self else { return }
            if let error {
                self.handleError(error)
            } else if let result {
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
                self.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: Error) {
        delegate?.showError("Oh no! Something went wrong: \(error.localizedDescription)")
    }

}
