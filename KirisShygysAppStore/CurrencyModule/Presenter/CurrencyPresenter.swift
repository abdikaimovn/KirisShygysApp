//
//  CurrencyPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 03.03.2024.
//

import UIKit

protocol CurrencyViewProtocol: AnyObject {
    func showCurrencyChangeAlert()
    func updateView()
}

final class CurrencyPresenter {
    weak var view: CurrencyViewProtocol?
    private var selectedCurrency: CurrencyEnum?
    private var currencyIndex: Int?
    
    func numberOfRowsInSection() -> Int {
        3
    }
    
    func viewDidLoaded() {
        selectedCurrency = UserDefaultsManager.fetchSelectedCurrency()
    }
    
    func didSelectItem(at index: Int) {
        currencyIndex = index
        view?.showCurrencyChangeAlert()
    }
    
    func userReplies(needToChange: Bool) {
        if needToChange {
            if let currency = currencyIndex {
                switch currency {
                case 0:
                    UserDefaultsManager.setSelectedCurrency(.tenge)
                case 1:
                    UserDefaultsManager.setSelectedCurrency(.dollar)
                case 2:
                    UserDefaultsManager.setSelectedCurrency(.ruble)
                default:
                    return
                }
                view?.updateView()
            }
        }
    }
    
    func dataForCell(at index: Int) -> CurrencyModel {
        switch index {
        case 0:
            return CurrencyModel(
                currencyImage: UIImage(systemName: "tengesign"),
                currencyName: "KZT",
                isSelected: CurrencyEnum.tenge == selectedCurrency ?? .tenge)
        case 1:
            return CurrencyModel(
                currencyImage:  UIImage(systemName: "dollarsign"),
                currencyName: "USD",
                isSelected: CurrencyEnum.dollar == selectedCurrency ?? .tenge)
        case 2:
            return CurrencyModel(
                currencyImage: UIImage(systemName: "rublesign"),
                currencyName: "RUB",
                isSelected: CurrencyEnum.ruble == selectedCurrency ?? .tenge)
        default:
            return CurrencyModel(
                currencyImage: UIImage(systemName: "tengesign"),
                currencyName: "KZT",
                isSelected: CurrencyEnum.tenge == selectedCurrency ?? .tenge)
        }
    }
}
