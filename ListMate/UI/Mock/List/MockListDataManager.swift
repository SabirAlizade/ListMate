//
//  MockListDataManager.swift
//  ListMate
//
//  Created by Sabir Alizade on 25.03.24.
//

import RealmSwift
import Foundation

protocol DataManagerProtocol {
    func saveObject<T: Object>(data: T, completion: @escaping(Error?) -> Void)
    func readData<T: Object>(data: T.Type, completion: @escaping (Results<T>?, Error?) -> Void)
    func delete<T: Object>(data: T, completion: @escaping(Error?) -> Void)
}

class MockListDataManager: DataManagerProtocol {
    var readDataCalled = false
    var deleteDataCalled = false
    var saveDataCalled = false
    var shouldReturnErrorOnRead = false
    var shouldReturnErrorOnDelete = false

    var mockLists: Results<ListModel>?

    func saveObject<T: Object>(data: T, completion: @escaping(Error?) -> Void) {
        saveDataCalled = true
        completion(nil)
    }
        
    func readData<T: Object>(data: T.Type, completion: @escaping (Results<T>?, Error?) -> Void) {
        readDataCalled = true
        if shouldReturnErrorOnRead {
            completion(nil, NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Read error"]))
        } else if let mockLists = mockLists as? Results<T> {
            completion(mockLists, nil)
        } else {
            let emptyResults = try! Realm().objects(data).filter("FALSEPREDICATE")
            completion(emptyResults, nil)
        }
    }
    
    func delete<T: Object>(data: T, completion: @escaping (Error?) -> Void) {
        deleteDataCalled = true
        if shouldReturnErrorOnDelete {
            completion(NSError(domain: "", code: 1, userInfo: nil))
        } else {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(data)
            }
            completion(nil)
        }
    }
}

class MockProductSession: ProductSessionProtocol {
    var listID: String = ""
    
    func updateListId(id: String) {
        listID = id
    }
}
