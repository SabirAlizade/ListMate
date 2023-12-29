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
    func passPrice(index: Int, price: Double)
}

class DetailedViewModel {
    weak var delegate: DetailedViewModelDelegate?
    var item: ItemModel?
    private let manager = DataManager()
    var cellIndex: Int?

    func updateValues(name: String, note: String) {
        guard let item else { return }
        do {
            try manager.realm.write {
                item.name = name
                item.notes = note
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    func updateValues(measeure: Measures, price: Double, store: String) {
        guard let item else { return }
        do {
            try manager.realm.write {
                item.measure = measeure
                item.price = price
                item.boughtAt = store
            }
        }
        catch {
            print(error.localizedDescription)
        }
        delegate?.passPrice(index: cellIndex! , price: price )
    }
    
    func updateImage(image: UIImage) {
         let imageString = image.description
        do {
            try manager.realm.write {
                item?.image = imageString
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func reloadItemsData() {
        delegate?.updateChanges()
    }
}
