//
//  MockListViewModelDelegate.swift
//  ListMate
//
//  Created by Sabir Alizade on 25.03.24.
//

import Foundation

class MockListViewModelDelegate: ListViewModelDelegate {
    var didReloadData = false
    var capturedErrorMessage: String?

    func reloadData() {
        didReloadData = true
    }
    
    func showError(_ message: String) {
        capturedErrorMessage = message
    }
}
