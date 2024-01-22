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

class CustomTextFieldConfiguration: UITextField, UITextFieldDelegate {
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
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func editingChanged() {
        guard let text = self.text else { return }
        let textWithoutCommas = text.replacingOccurrences(of: ",", with: ".")
        let components = textWithoutCommas.components(separatedBy: ".")
        if components.count > 2 {
            let formattedText = components.prefix(2).joined(separator: ".")
            self.text = formattedText
        } else {
            self.text = textWithoutCommas
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 9
    }
}

