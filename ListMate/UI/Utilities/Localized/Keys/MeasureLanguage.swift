//
//  MeasureLanguage.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

enum MeasureLanguage: LanguageProtocol {
    case pcs, kgs, l
    
    var translate: String {
        switch self {
            
        case .pcs:
            return "measure_app_pcs".localize
        case .kgs:
            return "measure_app_kgs".localize
        case .l:
            return "measure_app_l".localize
        }
    }
}
