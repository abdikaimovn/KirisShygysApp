//
//  LanguagesPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 29.02.2024.
//

import Foundation

protocol LanguageViewProtocol: AnyObject {
    func showLanguageChangeAlert()
    func restartApp()
}

final class LanguagePresenter {
    weak var view: LanguageViewProtocol?
    private var selectedLanguage: LanguageEnum?
    private var languageIndex: Int?
    
    func numberOfRowsInSection() -> Int {
        4
    }
    
    func viewDidLoaded() {
        selectedLanguage = UserDefaultsManager.fetchSelectedLanguage()
    }
    
    func userReplies(needToChange: Bool) {
        if needToChange {
            if let language = languageIndex {
                switch language {
                case 0:
                    UserDefaultsManager.setSelectedLanguage(.qazaqshaCyrillic)
                case 1:
                    UserDefaultsManager.setSelectedLanguage(.qazaqsha)
                case 2:
                    UserDefaultsManager.setSelectedLanguage(.russian)
                case 3:
                    UserDefaultsManager.setSelectedLanguage(.english)
                default:
                    return
                }
                view?.restartApp()
            }
        }
    }

    func didSelectItem(at index: Int) {
        languageIndex = index
        view?.showLanguageChangeAlert()
    }
    
    func dataForCell(at index: Int) -> LanguageModel {
        switch index {
        case 0:
            let language: LanguageEnum = .qazaqshaCyrillic
            return LanguageModel(
                languageImage: "🇰🇿",
                languageName: "Qazaqsha",
                isSelected: language == selectedLanguage ?? .qazaqshaCyrillic
            )
        case 1:
            let language: LanguageEnum = .qazaqsha
            return LanguageModel(
                languageImage: "🇰🇿",
                languageName: "Қазақша",
                isSelected: language == selectedLanguage ?? .qazaqshaCyrillic
            )
        case 2:
            let language: LanguageEnum = .russian
            return LanguageModel(
                languageImage: "🇷🇺",
                languageName: "Русский",
                isSelected: language == selectedLanguage ?? .qazaqshaCyrillic
            )
        case 3:
            let language: LanguageEnum = .english
            return LanguageModel(
                languageImage: "🇺🇸",
                languageName: "English",
                isSelected: language == selectedLanguage ?? .qazaqshaCyrillic
            )
        default:
            let language: LanguageEnum = .qazaqsha
            return LanguageModel(
                languageImage: "🇰🇿",
                languageName: "Қазақша",
                isSelected: language == selectedLanguage ?? .qazaqshaCyrillic
            )
        }
    }
}
