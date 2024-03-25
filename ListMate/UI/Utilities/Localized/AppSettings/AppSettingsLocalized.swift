//
//  AppSettingsLocalized.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

final class AppSettingsLocalized {
    
    private init() {}
    
    static let shared = AppSettingsLocalized()
    
    func localizedString(key: String) -> String {
        return setupLocalizedString(key: key)
    }
    
    private func setupLocalizedString(key: String) -> String {
        if let path = Bundle.main.path(forResource: UserDefaults.standard.language , ofType: "lproj") {
            if let bundle = Bundle(path: path) {
                let translateString = bundle.localizedString(forKey: key, value: nil, table: "Localizable")
                return translateString
            }
        }
        return ""
    }
}

