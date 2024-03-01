//
//  UserDefaultsManager.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 29.02.2024.
//

import Foundation

struct UserDefaultsManager {
    static func fetchSelectedLanguage() -> LanguageEnum {
        for language in LanguageEnum.allCases {
            if let selected = UserDefaults.standard.value(forKey: language.rawValue) as? Bool, selected == true {
                return language
            }
        }
        // Return .qazaqshaCyrillic if no language is selected
        return .qazaqshaCyrillic
    }
    
    static func setSelectedLanguage(_ language: LanguageEnum) {
        //Unselect all other languages
        LanguageEnum.allCases.forEach { UserDefaults.standard.set(false, forKey: $0.rawValue) }
        //Set true for selected language's value
        UserDefaults.standard.setValue(true, forKey: language.rawValue)
    }
}
