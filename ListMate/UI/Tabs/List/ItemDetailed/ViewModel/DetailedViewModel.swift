//
//  DetailedViewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 27.12.23.
//

import Foundation
import RealmSwift
import UIKit

protocol DetailedViewModelDelegate: AnyObject {
    func updateChanges()
}

class DetailedViewModel {
    weak var delegate: DetailedViewModelDelegate?
    var item: ItemModel?
    private let manager = DataManager()
    
    func updateValues(name: String, note: String) {
        guard let item else { return }
        do {
            try manager.realm.write {
                item.name = name
                item.notes = note
            }
        }
        catch {
            print("Error updating name or note \(error.localizedDescription)")
        }
    }
    
    func updateValues(measeure: Measures, price: Decimal128, store: String) {
        guard let item else { return }
        do {
            try manager.realm.write {
                item.measure = measeure
                item.price = price
                item.storeName = store
                item.totalPrice = item.amount * price
            }
        }
        catch {
            print("Error updating detailed item data \(error.localizedDescription)")
        }
        
        if let catalogItem = manager.realm.objects(CatalogModel.self).filter("name == %@", item.name).first {
            do {
                try manager.realm.write {
                    catalogItem.price = price
                }
                NotificationCenter.default.post(name: Notification.Name("ReloadCatalogData"), object: nil)
            }
            catch {
                print("Error updating catalog item price: \(error.localizedDescription)")
            }
        }
    }
    
    func updateImage(image: UIImage) {
        ImageManager.shared.saveImageToLibrary(image: image) { imagePath in
            do {
                try self.manager.realm.write {
                    self.item?.imagePath = imagePath
                }
            }
            catch {
                print("Error saving image to library \(error.localizedDescription)")
            }
        }
    }
    
    func reloadItemsData() {
        delegate?.updateChanges()
    }
}
