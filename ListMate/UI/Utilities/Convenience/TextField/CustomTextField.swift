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
                     border: BorderStyle = .roundedRect,
                     keyboard: UIKeyboardType = .default,
                     //                     image: UIImage? = nil,
                     dataSource: Any? = nil,
                     delegate: Any? = nil,
                     target: Any? = nil,
                     action: Selector? = nil
    ) {
        self.init()
        self.dataSource = dataSource as? TextFieldDataSource
        self.delegate = delegate as? UITextFieldDelegate
        self.textAlignment = textAlignment
        self.font = font
        keyboardType = keyboard
        textColor = .black
        layer.cornerRadius = 8
        borderStyle = border
        
        withBorder(width: 1, color: .buttongreen)
        // let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        // imageView.image = image
        // setLeftView(view: imageView)
        // height(50)
        attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.maingreen.withAlphaComponent(0.5)]
        )
        
        if let target = target, let action = action {
            addTarget(target, action: action, for: .editingChanged)
        }
    }
    
    func customizeBorder(width: CGFloat?, color: UIColor?) {
        self.layer.borderWidth = width ?? 0
        self.layer.borderColor = color?.cgColor
    }
}

class PriceTextField: PriceTextFieldConfiguration {
    private var previousValue: String?
    
    convenience init(placeHolder: String,
                     target: Any? = nil,
                     action: Selector? = nil
    ) {
        self.init()
        placeholder = placeHolder
        textAlignment = .left
        keyboardType = .decimalPad
        textColor = .black
        font = .poppinsFont(size: 20, weight: .regular)
        layer.cornerRadius = 8
        borderStyle = .roundedRect
        
        withBorder(width: 1, color: .buttongreen)
        attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.maingreen.withAlphaComponent(0.5)]
        )
        
        if let target = target, let action = action {
            addTarget(target, action: action, for: .editingChanged)
        }
        
        func customizeBorder(width: CGFloat?, color: UIColor?) {
            self.layer.borderWidth = width ?? 0
            self.layer.borderColor = color?.cgColor
        }
    }
}
