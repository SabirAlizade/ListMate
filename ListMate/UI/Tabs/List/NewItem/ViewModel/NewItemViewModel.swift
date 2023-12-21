//
//  NewItemIVewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 20.12.23.
//

import Foundation
import RealmSwift

protocol NewItemDelegate: AnyObject {
    func passAmountData(amount: Double)
    func reloadData()
}

final class NewItemViewModel {
    weak var delegate: NewItemDelegate?
    
    var measuresArray: [String] = ["Pcs", "Kgs", "L"]
    var selectedMeasure: Measures = .pcs
    var amountValue: Double = 1
    var item: Results<ItemsModel>?
    
    private let manager = DataManager()

    func saveItem(name: String,
                  price: Double,
                  image: String,
                  measure: Measures) {
        
        let item = ItemsModel(id: UUID(),
                              name: name,
                              amount: Double(1),
                              image: image,
                              measure: measure,
                              price: price)
                
        manager.saveObject(data: item) { result in
            switch result {
            case .success(let success):
                self.item = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        delegate?.reloadData()
    }

    func changeSelectedAmount(amount: Double) {
        delegate?.passAmountData(amount: amountValue)
        print(amountValue)
    }
}
