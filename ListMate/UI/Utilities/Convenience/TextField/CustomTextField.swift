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
                     backgroundColor: UIColor = .textfieldback,
                     keyboard: UIKeyboardType = .default,
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
        layer.cornerRadius = 8
        borderStyle = border
        textColor = .maintext
        self.backgroundColor = backgroundColor
        withBorder(width: 1, color: .buttongreen)
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
    
    convenience init(placeHolder: String,
                     target: Any? = nil,
                     action: Selector? = nil
    ) {
        self.init()
        placeholder = placeHolder
        textAlignment = .left
        keyboardType = .decimalPad
        font = .poppinsFont(size: 20, weight: .regular)
        layer.cornerRadius = 8
        borderStyle = .roundedRect
        textColor = .maintext
        self.backgroundColor = .textfieldback
        let priceImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        priceImageView.image = UIImage(named: "dollarsign")
        setRightView(view: priceImageView)
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

extension PriceTextField {
    func setRightView(view: UIView, padding: CGFloat = 20) {
        self.rightViewMode = .always
        let subView = UIView(frame: CGRect(x: -10, y: 0, width: padding, height: 50))
        view.backgroundColor = .textfieldback
        view.center = subView.center
        view.contentMode = .scaleAspectFit
        subView.addSubview(view)
        self.rightView = subView
    }
}
