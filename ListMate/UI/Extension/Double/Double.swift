//
//  Double.swift
//  ListMate
//
//  Created by Sabir Alizade on 30.12.23.
//

import Foundation

extension Double {
    static func doubleToString(double: Double) -> String {
        var string = String(format: "%.2f", double)
        
        switch string {
        case let str where str.hasSuffix(".00"):
            string = String(string.dropLast(3))
        case let str where str.hasSuffix(".0"):
            string = String(string.dropLast(2))
        case let str where str.contains(".") && str.hasSuffix("0"):
            string = String(string.dropLast(1))
            
        default:
            return string
        }
        return string
    }
}
