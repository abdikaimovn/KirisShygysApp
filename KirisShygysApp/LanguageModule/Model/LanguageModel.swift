//
//  LanguageModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 29.02.2024.
//

import Foundation

struct LanguageModel {
    let languageImage: String
    let languageName: String
    let isSelected: Bool
}

enum LanguageEnum: String, CaseIterable {
    case qazaqshaCyrillic = "kk"
    case qazaqsha = "kk-KZ"
    case english = "en"
    case russian = "ru"
}
