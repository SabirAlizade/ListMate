//
//  MockListViewModelDelegate.swift
//  ListMate
//
//  Created by Sabir Alizade on 25.03.24.
//

import Foundation

class MockListViewModelDelegate: ListViewModelDelegate {
    var didReloadData = false

    func reloadData() {
        didReloadData = true
    }
}
