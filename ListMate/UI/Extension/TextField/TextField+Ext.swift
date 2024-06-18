//
//  TextField+Ext.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

extension UITextField {
    
    func addShadowOnFocus() {
        addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        superview?.layer.masksToBounds = false
    }
    
    @objc private func textFieldDidBeginEditing() {
        addShadow()
    }
    
    @objc private func textFieldDidEndEditing() {
        removeShadow()
    }
    
    private func addShadow() {
        superview?.layer.shadowColor = UIColor.maingreen.cgColor
        superview?.layer.shadowOpacity = 0.5
        superview?.layer.shadowOffset = CGSize(width: 0, height: 2)
        superview?.layer.shadowRadius = 4
    }
    
    private func removeShadow() {
        superview?.layer.shadowOpacity = 0
    }
    
    //MARK: - Done accessory implementation
    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(
            title: LanguageBase.system(.doneKeyboardButton).translate,
            style: .done,
            target: self,
            action: #selector(self.doneButtonAction)
        )
        done.tintColor = .maingreen
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
