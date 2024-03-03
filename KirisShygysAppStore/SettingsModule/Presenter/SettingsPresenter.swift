//
//  SettingsPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 29.02.2024.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    func showLanguageModule()
    func showCurrencyModule()
}

final class SettingsPresenter {
    weak var view: SettingsViewProtocol?
    
    func numberOfRowsInSection() -> Int {
        4
    }
    
    func dataForItemAt(_ index: Int) -> MenuTableViewCellModel {
        switch index {
        case 0:
            return MenuTableViewCellModel(
                image: UIImage(systemName: "textformat"),
                title: "language_label".localized,
                color: .lightGrayColor)
        case 1:
            return MenuTableViewCellModel(
                image: UIImage(systemName: CurrencyHandler.fetchCurrencyImageName()),
                title: "currency_label".localized,
                color: .lightGrayColor)
        case 2:
            return MenuTableViewCellModel(
                image: UIImage(systemName: "person.text.rectangle"),
                title: "personalInfo_label".localized,
                color: .lightGrayColor)
        case 3:
            return MenuTableViewCellModel(
                image: UIImage(systemName: "trash"),
                title: "trash_label".localized,
                color: .expenseColor)
        default:
            return MenuTableViewCellModel(
                image: UIImage(systemName: "trash"),
                title: "trash_label".localized,
                color: .expenseColor)
        }
    }
    
    func didSelectRow(at index: Int) {
        switch index {
        case 0:
            view?.showLanguageModule()
        case 1:
            view?.showCurrencyModule()
        case 2:
            break
        case 3:
            break
        default:
            break
        }
    }
}
