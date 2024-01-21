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
        dataSource?.resultValue(hasText: hasText, value: text)
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
}

