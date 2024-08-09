//
//  ImagePickerLanguage.swift
//  ListMate
//
//  Created by Sabir Alizade on 09.02.24.
//

import Foundation

enum ImagePickerLanguage: LanguageProtocol {
    case chooseOption,
    takeImage,
    selectFromGallery,
    sourceAlarmTitle,
    sourceAlarmBody
    
    var translate: String {
        switch self {
            
        case .chooseOption:
            return "imagePicker_app_chooseOption".localize
        case .takeImage:
            return "imagePicker_app_takeImage".localize
        case .selectFromGallery:
            return "imagePicker_app_selectFromGallery".localize
        case .sourceAlarmTitle:
            return "imagePicker_app_sourceAlarmTitle".localize
        case .sourceAlarmBody:
            return "imagePicker_app_sourceAlarmBody".localize
        }
    }
}
