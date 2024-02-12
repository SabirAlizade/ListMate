//
//  ItemsLanguage.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

enum ItemLanguage: LanguageProtocol {
    case remainingTotal,
         completedTotal
    
    var translate: String {
        switch self {
            
        case .remainingTotal:
            return "item_app_remaining".localize
        case .completedTotal:
            return "item_app_completed".localize
        }
    }
}
