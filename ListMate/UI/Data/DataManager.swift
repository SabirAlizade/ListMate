//
//  DataManager.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import Foundation
import RealmSwift

class DataManager {
    
    let realm: Realm = try! Realm()
    
    
    func saveObject<T: Object>(data: T, completion: @escaping(Error?) -> Void) {
        do {
            try realm.write {
                realm.add(data)
            }
            completion(nil)
        }
        catch {
            completion(error)
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
    
    func filterID(id: String, completion: @escaping(Results<ItemModel>?) -> Void) {
        print(id)
        let predicate = NSPredicate(format: "id == %@", id)
        do {
            let realm = try Realm()
            let results = realm.objects(ItemModel.self).filter(predicate)
            if !results.isEmpty {
                DispatchQueue.main.async {
                    completion(results)
                }
            } else {
                print("NO DATA FOUND FOR ID \(id)")
                completion(nil)
            }
        } 
        catch {
            print("Error: \(error)")
        }
    }
}
