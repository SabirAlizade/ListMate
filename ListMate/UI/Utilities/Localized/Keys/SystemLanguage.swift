//
//  SystemLanguage.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

enum SystemLanguage: LanguageProtocol {
    case doneKeyboardButton, currency
    
    var translate: String {
        switch self {
            
        case .doneKeyboardButton:
            return "system_app_doneKeyboard".localize
        case .currency:
            return "system_app_currency".localize
        }
    }
}
