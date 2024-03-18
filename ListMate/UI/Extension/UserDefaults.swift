//
//  UserDefaults.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

extension UserDefaults {
    enum LangKeys: String {
        case language = "lang_key"
    }
    
    var language: String  {
        get {
            string(forKey: LangKeys.language.rawValue) ?? Locale.preferredLanguages.first ?? "en"
        }
        set {
            setValue(newValue, forKey: LangKeys.language.rawValue)
            synchronize()
        }
    }
}
