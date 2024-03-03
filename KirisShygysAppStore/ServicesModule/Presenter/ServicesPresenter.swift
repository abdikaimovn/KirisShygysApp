//
//  ServicesPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.02.2024.
//

import Foundation
import UIKit

protocol ServicesViewProtocol: AnyObject {
    func showTransactionReportModule(_ transactionsData: [ValidatedTransactionModel])
    func showStatisticsModule(_ transactionsData: [ValidatedTransactionModel])
    func showSettingsModule()
    func logOut()
    func showLoader()
    func hideLoader()
    func showNetworkFailure(_ failure: NetworkErrorModel)
    func showError(_ error: ErrorModel)
}

final class ServicesPresenter {
    weak var view: ServicesViewProtocol?
    private let authService: ServicesAuthenticationProtocol
    private let userDataService: ServicesDataManagerProtocol
    
    init(authService: ServicesAuthenticationProtocol, userDataService: ServicesDataManagerProtocol) {
        self.authService = authService
        self.userDataService = userDataService
    }
    
    private func logOut() {
        authService.logOut { [weak self] result in
            switch result {
            case .success():
                self?.view?.logOut()
            case .failure(let failure):
                self?.view?.showNetworkFailure(failure)
            }
        }
    }
    
    func numberOfRowsInSection() -> Int {
        4
    }
    
    func dataForItemAt(_ index: Int) -> MenuTableViewCellModel {
        switch index {
        case 0:
            return MenuTableViewCellModel(
                image: UIImage(systemName:"doc"),
                title: "transactionReport_label".localized,
                color: .lightGrayColor)
        case 1:
            return MenuTableViewCellModel(
                image: UIImage(systemName:"chart.bar.xaxis"),
                title: "statistics_label".localized,
                color: .lightGrayColor)
        case 2:
            return MenuTableViewCellModel(
                image: UIImage(systemName:"gear"),
                title: "settings_label".localized,
                color: .lightGrayColor)
        case 3:
            return MenuTableViewCellModel(
                image: UIImage(systemName:"rectangle.portrait.and.arrow.right"),
                title: "logout_label".localized,
                color: .lightBrownColor)
        default:
            return MenuTableViewCellModel(
                image: UIImage(systemName:"rectangle.portrait.and.arrow.right"),
                title: "logout_label".localized,
                color: .lightBrownColor)
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            view?.showLoader()
            userDataService.fetchLastMonthTransactionData { [weak self] result in
                self?.view?.hideLoader()
                switch result {
                case .success(let transactionsData):
                    if transactionsData.isEmpty {
                        self?.view?.showError(.reportLackData)
                        return
                    }
                    self?.view?.showTransactionReportModule(transactionsData)
                case .failure(let failure):
                    self?.view?.showNetworkFailure(failure)
                }
            }
        case 1:
            view?.showLoader()
            userDataService.fetchLastMonthTransactionData { [weak self] result in
                self?.view?.hideLoader()
                switch result {
                case .success(let transactionsData):
                    if transactionsData.isEmpty {
                        self?.view?.showError(.statisticsLackData)
                        return
                    }
                    self?.view?.showStatisticsModule(transactionsData)
                case .failure(let failure):
                    self?.view?.showNetworkFailure(failure)
                }
            }
        case 2:
            view?.showSettingsModule()
        case 3:
            logOut()
        default:
            return
        }
    }
}
