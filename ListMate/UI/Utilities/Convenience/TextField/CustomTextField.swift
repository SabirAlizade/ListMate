//
//  CustomTextField.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

class CustomTextField: CustomTextFieldConfiguration {
    
    convenience init(placeHolder: String,
                     textAlignment: NSTextAlignment = .left,
                     font: UIFont = .poppinsFont(size: 20, weight: .regular),
                     keybord: UIKeyboardType = .default,
//                     image: UIImage? = nil,
                     dataSource: Any? = nil,
                     delegate: Any? = nil,
                     target: Any? = nil,
                     action: Selector? = nil) {
        self.init()
        self.dataSource = dataSource as? any TextFieldDataSource
        self.delegate = delegate as? any UITextFieldDelegate
        self.textAlignment = textAlignment
        self.font = font
        keyboardType = keybord
        textColor = .darkText
        layer.cornerRadius = 13
        borderStyle = .roundedRect
        withBorder(width: 1, color: .buttongreen)
      //  let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
//        imageView.image = image
//        setLeftView(view: imageView)
        height(50)
        attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.maingreen.withAlphaComponent(0.5)]
        )
        
        if let target = target, let action = action {
            addTarget(target, action: action, for: .editingChanged)
        }
    }
}

