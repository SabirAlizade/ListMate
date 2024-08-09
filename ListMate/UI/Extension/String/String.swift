//
//  String.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

extension String {
    var localize: String {
        return AppSettingsLocalized.shared.localizedString(key: self)
    }
}
