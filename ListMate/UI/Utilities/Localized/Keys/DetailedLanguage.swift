//
//  DetailedLanguage.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

enum DetailedLanguage: LanguageProtocol {
    case addNotePlaceHolder,
         measureLabel,
         priceLabel,
         storeLabel,
         storePlaceHolder
    
    var translate: String {
        switch self {
            
        case .addNotePlaceHolder:
            return "detailed_app_addNotePlaceHolder".localize
        case .measureLabel:
            return "detailed_app_measureLabel".localize
        case .priceLabel:
            return "detailed_app_priceLabel".localize
        case .storeLabel:
            return "detailed_app_storeLabel".localize
        case .storePlaceHolder:
            return "detailed_app_storePlaceHolder".localize
        }
    }
}
