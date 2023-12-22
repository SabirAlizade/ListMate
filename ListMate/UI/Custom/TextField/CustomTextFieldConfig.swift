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

class AmountTextField: UITextField {
    
    func setLeftView(view: UIView, padding: CGFloat = 60) {
        self.leftViewMode = .always
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 50))
        view.frame = CGRect(x: 0, y: 0, width: padding, height: 50)
        view.center = subView.center
        view.tintColor = .maingreen
        view.contentMode = .scaleAspectFit
        subView.addSubview(view)
        self.leftView = subView
    }
    
    func setRightView(view: UIView, padding: CGFloat = 60) {
        self.rightViewMode = .always
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 50))
        view.frame = CGRect(x: 0, y: 0, width: padding, height: 50)
        view.center = subView.center
        view.tintColor = .maingreen
        view.contentMode = .scaleAspectFit
        subView.addSubview(view)
        self.rightView = subView
    }
    
}
