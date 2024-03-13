//
//  SettingsPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 29.02.2024.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    func showLanguageModule()
    func showClearHistoryAlert(_ title: String, _ message: String)
    func showDeleteAccountAlert(_ title: String, _ message: String)
    func updateView()
    func showFailure(_ failure: NetworkErrorModel)
    func showLoader()
    func hideLoader()
    func showPersonalInfoModule()
    func showInitialModule()
}

final class SettingsPresenter {
    weak var view: SettingsViewProtocol?
    private let userDataService: ServicesDataManagerProtocol
    private let authService: ServicesAuthenticationProtocol
    
    init(userDataService: ServicesDataManagerProtocol, authService: ServicesAuthenticationProtocol) {
        self.userDataService = userDataService
        self.authService = authService
    }
    
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
                image: UIImage(systemName: "person.text.rectangle"),
                title: "personalInfo_label".localized,
                color: .lightGrayColor)
        case 2:
            return MenuTableViewCellModel(
                image: UIImage(systemName: "trash"),
                title: "trash_label".localized,
                color: .expenseColor)
        case 3:
            return MenuTableViewCellModel(
                image: UIImage(systemName: "xmark"),
                title: "deleteAccount_label".localized,
                color: .expenseColor)
        default:
            return MenuTableViewCellModel(
                image: UIImage(systemName: "trash"),
                title: "trash_label".localized,
                color: .expenseColor)
        }
    }
    
    func userClearHistoryReply(_ needToDelete: Bool) {
        if needToDelete {
            view?.showLoader()
            userDataService.removeAllHistoryData { [weak self] result in
                self?.view?.hideLoader()
                switch result {
                case .success(_):
                    self?.view?.updateView()
                case .failure(let failure):
                    self?.view?.showFailure(failure)
                }
            }
        }
    }
    
    func userDeleteAccountReply(_ needToDelete: Bool) {
        if needToDelete {
            view?.showLoader()
            authService.deleteUser { [weak self] result in
                self?.view?.hideLoader()
                switch result {
                case .success(_):
                    self?.view?.showInitialModule()
                case .failure(let failure):
                    self?.view?.showFailure(failure)
                }
            }
        }
    }
    
    func didSelectRow(at index: Int) {
        switch index {
        case 0:
            view?.showLanguageModule()
        case 1:
            view?.showPersonalInfoModule()
        case 2:
            view?.showClearHistoryAlert("warning_title".localized, "clearHistory_message".localized)
        case 3:
            view?.showDeleteAccountAlert("warning_title".localized, "deleteAccount_message".localized)
        default:
            break
        }
    }
}
