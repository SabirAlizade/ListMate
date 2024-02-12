//
//  File.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

enum Languages: CaseIterable {
    case en, ru, az
    
    var key: String {
        switch self {
        case .en: return "en"
        case .ru: return "ru"
        case .az: return "az"
        }
    }
}
