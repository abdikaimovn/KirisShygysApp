//
//  UIString+Extension.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.01.2024.
//

import Foundation

extension String {
    var localized: String {
        let selectedLanguage = UserDefaultsManager.fetchSelectedLanguage()
        if let path = Bundle.main.path(forResource: selectedLanguage.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        } else {
            return NSLocalizedString(self, comment: "")
        }
    }
    
    static var currentCurrency: String {
        UserDefaultsManager.fetchSelectedCurrency().rawValue.localized
    }
}
