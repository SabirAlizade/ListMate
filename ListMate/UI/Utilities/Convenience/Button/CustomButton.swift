//
//  CustomButton.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

class CustomButton: UIButton {
    
    convenience init(title: String,
                     backgroundColor: UIColor,
                     titleColor: UIColor,
                     target: Any?,
                     action: Selector?) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 13
        titleLabel?.font = .poppinsFont(size: 20, weight: .regular)
        height(50)
        if let target = target, let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
}

class FloatingButton: UIButton {
    
    let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 50))
    
    convenience init(target: Any?, action: Selector?) {
        self.init(type: .system)
        setImage(UIImage(named: "plusButton")?.withConfiguration(config), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        if let target = target, let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
}
