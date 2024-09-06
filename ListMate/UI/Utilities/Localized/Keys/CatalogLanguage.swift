//
//  CatalogLanguage.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

enum CatalogLanguage: LanguageProtocol {
    case title,
         milk,
         bread,
         butter,
         bananas,
         eggs,
         potatoes,
         tomatoes,
         water,
         orangeJuice,
         chicken,
         cheese,
         apples,
         yougurt,
         pasta,
         rice,
         itemName,
        lastPrice
    
    var translate: String {
        switch self {
            
        case .title:
            return "catalog_app_title".localize
        case .milk:
            return "catalog_app_milk".localize
        case .bread:
            return "catalog_app_bread".localize
        case .butter:
            return "catalog_app_butter".localize
        case .bananas:
            return "catalog_app_bananas".localize
        case .eggs:
            return "catalog_app_eggs".localize
        case .potatoes:
            return "catalog_app_potatoes".localize
        case .tomatoes:
            return "catalog_app_tomatoes".localize
        case .water:
            return "catalog_app_water".localize
        case .orangeJuice:
            return "catalog_app_orangeJuice".localize
        case .chicken:
            return "catalog_app_chicken".localize
        case .cheese:
            return "catalog_app_cheese".localize
        case .apples:
            return "catalog_app_apples".localize
        case .yougurt:
            return "catalog_app_yougurt".localize
        case .pasta:
            return "catalog_app_pasta".localize
        case .rice:
            return "catalog_app_rice".localize
        case .itemName:
            return "catalog_app_item_name".localize
        case .lastPrice:
            return "catalog_app_last_price".localize
        }
    }
}
