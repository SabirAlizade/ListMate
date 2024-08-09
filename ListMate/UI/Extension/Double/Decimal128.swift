//
//  Decimal128.swift
//  ListMate
//
//  Created by Sabir Alizade on 02.02.24.
//

import Foundation
import RealmSwift

extension Decimal128 {
    static func fromStringToDecimal(string: String) -> Decimal128? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        
        if let number = formatter.number(from: string) {
            let decimalNumber = NSDecimalNumber(decimal: number.decimalValue)
            return Decimal128(value: decimalNumber)
        }
        return nil
    }
}
