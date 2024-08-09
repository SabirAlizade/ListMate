//
//  SummaryLanguage.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

enum SummaryLanguage: LanguageProtocol {
    case title,
         thankLabel,
         totalLabel
    
    var translate: String {
        switch self {
            
        case .title:
            return "summary_app_title".localize
        case .thankLabel:
            return "summary_app_thankLabel".localize
        case .totalLabel:
            return "summary_app_totalLabel".localize
        }
    }
}
