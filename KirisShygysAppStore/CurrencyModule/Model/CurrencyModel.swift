//
//  CurrencyModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 03.03.2024.
//

import UIKit

struct CurrencyModel {
    let currencyImage: UIImage?
    let currencyName: String
    let isSelected: Bool
}

enum CurrencyEnum: String, CaseIterable {
    case tenge = "tenge"
    case ruble = "ruble"
    case dollar = "dollar"
}

struct CurrencyHandler {
    static func fetchCurrencyImageName() -> String {
        switch UserDefaultsManager.fetchSelectedCurrency() {
        case .tenge:
            return "tengesign"
        case .ruble:
            return "rublesign"
        case .dollar:
            return "dollarsign"
        }
    }
}
