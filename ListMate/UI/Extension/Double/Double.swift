//
//  Double.swift
//  ListMate
//
//  Created by Sabir Alizade on 30.12.23.
//

import Foundation

extension Double {
    static func doubleToString(double: Double) -> String {
        var string = String(format: "%.1f", double)
        if string.hasSuffix(".0") {
            string = String(string.dropLast(2))
        }
        return string
    }
}
