//
//  CustomTextField.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

protocol TextFieldDataSource {
    func resultValue(hasText: Bool, value: String)
}

class CustomTextFieldConfiguration: UITextField {
    var dataSource: TextFieldDataSource?
    private var maxCharacterCount = 26
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doneAccessory = true
        addTarget(self, action: #selector(didChangeValue(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didChangeValue(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            dataSource?.resultValue(hasText: false, value: "")
            return
        }
        if text == " " {
            self.text = nil
        }
        
        if text.count > maxCharacterCount {
            let index = text.index(text.startIndex, offsetBy: maxCharacterCount)
            self.text = String(text.prefix(upTo: index))
        }
        dataSource?.resultValue(hasText: !text.isEmpty, value: text)
    }
}

class PriceTextFieldConfiguration: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        doneAccessory = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        guard let decimalSeparator = Locale.current.decimalSeparator else {
            return true
        }
        
        if newText.components(separatedBy: decimalSeparator).count > 2 {
            return false
        }
        
        let filteredText = newText.replacingOccurrences(of: ",", with: ".")
        let components = filteredText.components(separatedBy: ".")
        if components.count > 2 || (components.count == 2 && components[1].count > 2) {
            return false
        }
        
        textField.text = filteredText
        sendActions(for: .editingChanged)
        
        return true
    }
}
