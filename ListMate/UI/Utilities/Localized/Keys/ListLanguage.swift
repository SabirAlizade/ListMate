//
//  ListsLanguage.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

enum ListLanguage: LanguageProtocol {
    case title,
         emptyListLabel,
         newListTitle,
         newListPlaceholder,
         saveButton,
         emptyNameAlarmTitle,
         emptyNameAlarmBody
    
    var translate: String {
        switch self {
            
        case .title:
            return "list_app_title".localize
        case .emptyListLabel:
            return "list_app_emptyListLabel".localize
        case .newListTitle:
            return "list_app_newListTitle".localize
        case .newListPlaceholder:
            return "list_app_newListPlaceHolder".localize
        case .saveButton:
            return "list_app_saveButton".localize
        case .emptyNameAlarmTitle:
            return "list_app_emptyNameAlarmTitle".localize
        case .emptyNameAlarmBody:
            return "list_app_emptyNameAlarmBody".localize
        }
    }
}
