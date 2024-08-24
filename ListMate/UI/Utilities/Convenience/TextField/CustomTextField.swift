//
//  CustomTextField.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

class CustomTextField: CustomTextFieldConfiguration {
    
    convenience init(
        placeHolder: String,
        textAlignment: NSTextAlignment = .left,
        font: UIFont = .poppinsFont(size: 20, weight: .regular),
        border: BorderStyle = .roundedRect,
        backgroundColor: UIColor = .textfieldBlack,
        keyboard: UIKeyboardType = .default,
        dataSource: Any? = nil,
        delegate: Any? = nil,
        target: Any? = nil,
        action: Selector? = nil
    ) {
        self.init()
        clipsToBounds = true
        self.dataSource = dataSource as? TextFieldDataSource
        self.delegate = delegate as? UITextFieldDelegate
        self.textAlignment = textAlignment
        self.font = font
        keyboardType = keyboard
        layer.cornerRadius = 8
        borderStyle = border
        textColor = .mainText
        self.backgroundColor = backgroundColor
        withBorder(width: 1, color: .buttonGreen)
        attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mainGreen.withAlphaComponent(0.5)]
        )
        
        if let target = target, let action = action {
            addTarget(target, action: action, for: .editingChanged)
        }
    }
    
    func customizeBorder(width: CGFloat?, color: UIColor?) {
        self.layer.borderWidth = width ?? 0
        self.layer.borderColor = color?.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addShadowOnFocus()
    }
}

class PriceTextField: PriceTextFieldConfiguration {
    
    convenience init(
        placeHolder: String,
        target: Any? = nil,
        action: Selector? = nil
    ) {
        self.init()
        clipsToBounds = true
        placeholder = placeHolder
        textAlignment = .left
        keyboardType = .decimalPad
        font = .poppinsFont(size: 20, weight: .regular)
        layer.cornerRadius = 8
        borderStyle = .roundedRect
        textColor = .mainText
        self.backgroundColor = .textfieldBlack
        updateRightView()
        withBorder(width: 1, color: .mainGreen)
        
        attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mainGreen.withAlphaComponent(0.5)]
        )
        
        if let target = target, let action = action {
            addTarget(target, action: action, for: .editingChanged)
        }
        
        func customizeBorder(width: CGFloat?, color: UIColor?) {
            self.layer.borderWidth = width ?? 0
            self.layer.borderColor = color?.cgColor
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addShadowOnFocus()
    }
    
    private func updateRightView() {
        let priceImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let languageCode = Locale.current.language.languageCode?.identifier
        switch languageCode {
        case "en":
            priceImageView.image = UIImage(named: "dollarSign")
        case "ru":
            priceImageView.image = UIImage(named: "roubleSign")
        case "az":
            priceImageView.image = UIImage(named: "manatSign")
        default:
            priceImageView.image = UIImage(named: "dollarSign")
        }
        setRightView(view: priceImageView)
    }
    
    // MARK: Preventing paste to textfield
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

extension PriceTextField {
    func setRightView(view: UIView, padding: CGFloat = 20) {
        self.rightViewMode = .always
        let subView = UIView(frame: CGRect(x: -10, y: 0, width: padding, height: 50))
        view.backgroundColor = .textfieldBlack
        view.center = subView.center
        view.contentMode = .scaleAspectFit
        subView.addSubview(view)
        self.rightView = subView
    }
}

