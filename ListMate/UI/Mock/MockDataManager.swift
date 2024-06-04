//
//  MockDataManager.swift
//  ListMate
//
//  Created by Sabir Alizade on 25.03.24.
//

import RealmSwift

protocol DataManagerProtocol {
    func saveObject<T: Object>(data: T, completion: @escaping(Error?) -> Void)
    func readData<T: Object>(data: T.Type, completion: @escaping(Results<T>) -> Void)
    func delete<T: Object>(data: T, completion: @escaping(Error?) -> Void)
    // Add any other methods your DataManager provides
}

class MockDataManager: DataManagerProtocol {
    var readDataCalled = false
    var deleteDataCalled = false
    var saveDataCalled = false

    var mockLists: Results<ListModel>? // You will need to adjust this to simulate Realm's Results

    // Implement the DataManagerProtocol methods here
    func saveObject<T: Object>(data: T, completion: @escaping(Error?) -> Void) {
        saveDataCalled = true
        // Simulate save operation success or failure
    }
    
    func readData<T: Object>(data: T.Type, completion: @escaping(Results<T>) -> Void) {
        readDataCalled = true
        // Return mock data or simulate a failure
        if let mockLists = mockLists as? Results<T> {
            completion(mockLists)
        }
    }
    
    func delete<T: Object>(data: T, completion: @escaping(Error?) -> Void) {
        deleteDataCalled = true
        // Simulate delete operation success or failure
    }
}
