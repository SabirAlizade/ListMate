//
//  NewItemIVewModel.swift
//  ListMate
//
//  Created by Sabir Alizade on 20.12.23.
//

import Foundation
import RealmSwift

protocol NewItemDelegate: AnyObject {
//    func passAmountData(amount: Double)
    func reloadAndFilterData()
}

final class NewItemViewModel {
    weak var delegate: NewItemDelegate?
    
    var measuresArray: [String] = ["Pcs", "Kgs", "L"]
    var selectedMeasure: Measures = .pcs
    private var amountValue: Double = 1
    var item: Results<ItemModel>?
    
    private let session: ProductSession
    
    init(session: ProductSession) {
        self.session = session
    }
    
    private let manager = DataManager()
    
    func saveItem(name: String,
                  price: Double,
                  image: String,
                  measure: Measures) {
        
        let item = ItemModel(id: session.listID,
                             name: name,
                             amount: amountValue,
                             image: image,
                             measure: measure,
                             price: price,
                             totalPrice: price)
        
        manager.saveObject(data: item) {  error in
            if let err = error {
                print(err.localizedDescription)
            }
        }
        print("NEW ITEM \(item)")
        delegate?.reloadAndFilterData()
    }
    
    func setAmount(amount: Double) {
        amountValue = amount
    }
    
//    func changeSelectedAmount(amount: Double) {
//        delegate?.passAmountData(amount: amountValue)
//    }
}
