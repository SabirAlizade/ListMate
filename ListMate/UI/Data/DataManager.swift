//
//  DataManager.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import Foundation
import RealmSwift

class DataManager: DataManagerProtocol {
    
    let realm: Realm = try! Realm()
    
    func saveObject<T: Object>(data: T, completion: @escaping(Error?) -> Void) {
        do {
            try realm.write {
                realm.add(data)
            }
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func readData<T: Object>(data: T.Type, completion: @escaping (Results<T>?, Error?) -> Void) {
        let result = realm.objects(data)
        completion(result, nil)
    }
    
    func delete<T: Object>(data: T, completion: @escaping(Error?) -> Void) {
        do {
            try realm.write {
                realm.delete(data)
            }
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func filterID(id: String, completion: @escaping(Results<ItemModel>?) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id)
        do {
            let realm = try Realm()
            let results = realm.objects(ItemModel.self).filter(predicate)
            DispatchQueue.main.async {
                completion(results.isEmpty ? nil : results)
            }
        } catch {
            print("Error: \(error)")
            completion(nil)
        }
    }
    
    func filterObjects<T: Object>(
        type: T.Type,
        predicate: NSPredicate,
        completion: @escaping (Results<T>) -> Void
    ) {
        let results = realm.objects(type).filter(predicate)
        completion(results)
    }
}
