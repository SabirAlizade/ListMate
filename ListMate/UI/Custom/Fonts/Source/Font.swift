//
//  Font.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

enum WeightType: String {
    case light = "Poppins-Light"
    case regular = "Poppins-Regular"
    case semiBold = "Poppins-SemiBold"
}

extension UIFont {
    
    static func poppinsFont(size: CGFloat, weight forKey: WeightType) -> UIFont {
        if let font = UIFont(name: forKey.rawValue, size: size) {
            return font
        } else {
            print("Font not found")
            return UIFont()
        }
    }
}
