//
//  Language.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

protocol LanguageProtocol {
    var translate: String { get }
}

enum LanguageBase: LanguageProtocol {
    
    case list(ListLanguage)
    case item(ItemLanguage)
    case summary(SummaryLanguage)
    case detailed(DetailedLanguage)
    case newItem(NewItemLanguage)
    case catalog(CatalogLanguage)
    case system(SystemLanguage)
    case imagePicker(ImagePickerLanguage)
    case measure(MeasureLanguage)
    
    var translate: String {
        switch self {
        case .list(let list):
            return list.translate
        case .item(let item):
            return item.translate
        case .summary(let summary):
            return summary.translate
        case .detailed(let detailed):
            return detailed.translate
        case .newItem(let newItem):
            return newItem.translate
        case .catalog(let catalog):
            return catalog.translate
        case .system(let system):
            return system.translate
        case .imagePicker(let imagePicker):
            return imagePicker.translate
        case .measure(let measure):
            return measure.translate
        }
    }
}
