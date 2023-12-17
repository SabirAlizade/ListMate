//
//  CustomLabel.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class CustomLabel: UILabel {
    
    convenience init(text: String? = nil,
                     textColor: UIColor = .darkText,
                     font: UIFont = .poppinsFont(size: 20, weight: .regular),
                     alignment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.textAlignment = alignment
        self.font = font
    }
}
