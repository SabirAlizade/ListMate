//
//  NewItemLanguage.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

enum NewItemLanguage: LanguageProtocol {
    case newItemTitle,
         newItemNamePlaceHolder,
         priceLabel,
         quantityLabel,
         addButton,
         emptyNameAlarmTitle,
         emptyNameAlarmBody,
         wrongPriceAlarmTitle,
         wrongPriceAlarmBody
    
    var translate: String {
        switch self {
            
        case .newItemTitle:
            return "newItem_app_title".localize
        case .newItemNamePlaceHolder:
            return "newItem_app_namePlaceHolder".localize
        case .priceLabel:
            return "newItem_app_priceLabel".localize
        case .quantityLabel:
            return "newItem_app_quantityLabel".localize
        case .addButton:
            return "newItem_app_addButton".localize
        case .emptyNameAlarmTitle:
            return "newItem_app_emptyNameAlarmTitle".localize
        case .emptyNameAlarmBody:
            return "newItem_app_emptyNameAlarmBody".localize
        case .wrongPriceAlarmTitle:
            return "newItem_app_wrongPriceAlarmTitle".localize
        case .wrongPriceAlarmBody:
            return "newItem_app_wrongPriceAlarmBody".localize
        }
    }
}
