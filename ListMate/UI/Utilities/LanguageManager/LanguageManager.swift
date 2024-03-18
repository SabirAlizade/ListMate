//
//  LanguageManager.swift
//  ListMate
//
//  Created by Sabir Alizade on 11.02.24.
//

import Foundation

class LanguageManager {
    static let shared  = LanguageManager()
    private let languageKey = "AppLanguage"
    
    private init() {}
    
    func setupLanguage() {
        let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        UserDefaults.standard.language = systemLanguage
        
        let previousLanguage = UserDefaults.standard.string(forKey: languageKey) ?? "en"
        
        if systemLanguage != previousLanguage {
            clearMockCatalogData()
            UserDefaults.standard.set(systemLanguage, forKey: languageKey)
        }
    }
    
    private func clearMockCatalogData() {
        CatalogViewModel().clearMockData()
    }
}
