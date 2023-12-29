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
    
    func filterID(id: String, completion: @escaping(Results<ItemModel>?) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id)
        do {
            let realm = try Realm()
            let results = realm.objects(ItemModel.self).filter(predicate)
            if !results.isEmpty {
                DispatchQueue.main.async {
                    completion(results)
                }
            } else {
                completion(nil)
            }
        }
        catch {
            print("Error: \(error)")
        }
    }
    
    func filterObjects<T: Object>(type: T.Type,
                                  predicate: NSPredicate,
                                  completion: @escaping (Results<T>) -> Void) {
        let results = realm.objects(type).filter(predicate)
        completion(results)
    }
}

/*
 func updateObject<T: Object>(data: T, completion: @escaping(Error?) -> Void) {
     do {
         try realm.write {
             realm.add(data, update: .modified)
         }
         completion(nil)
     }
     catch {
         completion(error)
     }
 }
 */

//    func updateSummary(listID: String, completion: @escaping(Error?) -> Void) {
//
//        if let uuid = UUID(uuidString: listID) {
//            if let listModel = realm.object(ofType: ListModel.self, forPrimaryKey: uuid) {
//                if let totalPricesSum = listModel.items.sum(ofProperty: "totalPrice") as Double? {
//                    do {
//                        try realm.write {
//                            listModel.totalAmount = totalPricesSum
//                            print(totalPricesSum)
//                        }
//                        completion(nil)
//                    }
//                    catch {
//                        completion(error)
//                    }
//                }
//            }
//        }
//    }

