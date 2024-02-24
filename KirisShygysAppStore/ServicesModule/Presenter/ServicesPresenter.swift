//
//  ServicesPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.02.2024.
//

import Foundation

protocol ServicesViewProtocol: AnyObject {
    func showTransactionReportModule(_ transactionData: [ValidatedTransactionModel])
    func showStatisticsModule(_ transactionData: [ValidatedTransactionModel])
    func showSettingsModule()
    func logOut()
    func showLoader()
    func hideLoader()
    func showFailure(_ networkError: NetworkErrorModel)
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
                self?.view?.showFailure(failure)
            }
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
                        self?.view?.showFailure(
                            NetworkErrorModel(
                                title: "lackDataAlert_title".localized,
                                error: nil,
                                text: nil,
                                description: "reportLackDataAlert_message".localized)
                        )
                        return
                    }
                    self?.view?.showTransactionReportModule(transactionsData)
                case .failure(let failure):
                    self?.view?.showFailure(failure)
                }
            }
        case 1:
            view?.showLoader()
            userDataService.fetchLastMonthTransactionData { [weak self] result in
                self?.view?.hideLoader()
                switch result {
                case .success(let transactionsData):
                    if transactionsData.isEmpty {
                        self?.view?.showFailure(
                            NetworkErrorModel(
                                title: "lackDataAlert_title".localized,
                                error: nil,
                                text: nil,
                                description: "statisticsLackDataAlert_message".localized)
                        )
                        return
                    }
                    self?.view?.showStatisticsModule(transactionsData)
                case .failure(let failure):
                    self?.view?.showFailure(failure)
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
