//
//  TextField+Ext.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

extension UITextField {
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
    
//    func setLeftView(view: UIView, padding: CGFloat = 60) {
//        self.leftViewMode = .always
//        let subView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 50))
//        view.backgroundColor = .white
//        view.frame = CGRect(x: 0, y: 0, width: padding, height: 25)
//        view.center = subView.center
//        view.tintColor = .maingreen
//        view.contentMode = .scaleAspectFit
//        subView.addSubview(view)
//        self.leftView = subView
//    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
