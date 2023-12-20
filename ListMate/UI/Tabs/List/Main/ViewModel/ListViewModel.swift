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
    
    func readData() {
        manager.readData(data: ListModel.self) { result in
            self.lists = result
        }
    }
}
