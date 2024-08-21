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
            guard let language = string(forKey: LangKeys.language.rawValue) else {
                return Locale.preferredLanguages.first ?? "en"
            }
            return language
        }
        set {
            setValue(newValue, forKey: LangKeys.language.rawValue)
        }
    }
}
