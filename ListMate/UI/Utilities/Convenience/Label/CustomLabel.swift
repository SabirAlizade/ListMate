//
//  CustomLabel.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class CustomLabel: UILabel {
    
    convenience init(text: String? = nil,
                     textColor: UIColor = .maintext,
                     font: UIFont = .poppinsFont(size: 20, weight: .regular),
                     alignment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.textAlignment = alignment
        self.font = font
    }
}

//
//class CurrencyLabel: UILabel {
//    
//    convenience init(textColor: UIColor = .maintext,
//                     font: UIFont = .poppinsFont(size: 20, weight: .regular),
//                     alignment: NSTextAlignment = .right) {
//        let currencySymbol = AppSettingsLocalized.shared.getCurrencySymbol()
//
//        self.init()
//        self.text = currencySymbol
//        self.textColor = textColor
//        self.textAlignment = alignment
//        self.font = font
//    }
//}
