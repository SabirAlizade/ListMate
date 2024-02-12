//
//  LanguageManager.swift
//  ListMate
//
//  Created by Sabir Alizade on 11.02.24.
//

import Foundation

class LanguageManager {
    static let shared  = LanguageManager()
    
    private init() {}
    
    func setupLanguage() {
        let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        UserDefaults.standard.language = systemLanguage
    }
}
