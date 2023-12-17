//
//  DataManager.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import Foundation
import RealmSwift

class DataManager {
    
    private let realm: Realm = try! Realm()
    
    func saveObject<T: Object>(data: T, completion: @escaping(Result<Results<T>, Error>) -> Void) {
        do {
            try realm.write {
                realm.add(data)
            }
            readData(data: T.self) { result in
                completion(.success(result))
            }
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func readData<T: Object>(data: T.Type, completion: @escaping(Results<T>) -> Void) {
        let result = realm.objects(data)
        completion(result)
    }
    
    func delete<T: Object>(data: T, completion: @escaping(Error?) -> Void) {
        do {
            try realm.write {
                realm.delete(data)
            }
        }
        catch {
            completion(error)
        }
    }
    
    func updateObject<T: Object>(data: T, completion: @escaping(Error?) -> Void) {
        do {
            try realm.write {
                realm.add(data, update: .all)
            }
        }
        catch {
            completion(error)
        }
    }
    
}
