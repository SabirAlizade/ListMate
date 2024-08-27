//
//  Date+Ext.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import Foundation

enum DateFormatterType: String {
    case dotType = "dd.MM.yyyy"
}

extension Date {
    func convertDate(format: DateFormatterType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let date = dateFormatter.string(from: self)
        return  date
    }
}
