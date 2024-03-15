//
//  HomePresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 11.02.2024.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    func setUsername(username: String)
    func setCardValues(total: String, expenses: String, incomes: String)
    func reloadTransactionTableView()
    func showHistoryModule(transactionsData: [ValidatedTransactionModel])
    func showFailure(with error: NetworkErrorModel)
    func showAbsenceDataFailure(_ failure: ErrorModel)
}

final class HomePresenter {
    weak var view: HomeViewProtocol?
    private let networkService: HomeServiceProtocol
    private var transactionData: [ValidatedTransactionModel]?
    
    init(networkService: HomeServiceProtocol) {
        self.networkService = networkService
    }
    
    func showAllTransactionsTapped() {
        guard let safeData = transactionData, !safeData.isEmpty else {
            view?.showAbsenceDataFailure(.historyLackData)
            return
        }
        
        view?.showHistoryModule(transactionsData: safeData)
    }
    
    private func calculateCardValues(data: [ValidatedTransactionModel]) -> CardModel {
        var incomes = 0
        var expenses = 0
        var total = 0
        
        for transaction in data {
            let transactionType = transaction.transactionType
            let transactionAmount = transaction.transactionAmount
            
            switch transactionType {
            // Counting expenses and total
            case .expense:
                expenses += transactionAmount
                total -= transactionAmount
            // Counting incomes and total
            case .income:
                incomes += transactionAmount
                total += transactionAmount
            }
            
        }
        
        return CardModel(total: total, incomes: incomes, expenses: expenses)
    }
    
    func numberOfRowsInSection() -> Int {
        transactionData?.count ?? 0
    }
    
    func dataForRowAt(_ index: Int) -> ValidatedTransactionModel? {
        transactionData?[index]
    }
    
    func viewDidLoaded() {
        view?.showLoader()
        
        networkService.fetchUsername { [weak self] result in
            switch result {
            case .success(let username):
                self?.view?.setUsername(username: username)
            case .failure(let error):
                self?.view?.showFailure(with: error)
            }
        }
        
        networkService.fetchTransactionsData { [weak self] result in
            self?.view?.hideLoader()
            
            switch result {
            case .success(let transactionData):
                self?.transactionData = transactionData
                
                let cardModel = self?.calculateCardValues(data: transactionData)
                
                self?.view?.setCardValues(
                    total: "\("tenge".localized) \(cardModel?.total.formattedWithSeparator ?? "0")",
                    expenses: "\("tenge".localized) \(cardModel?.expenses.formattedWithSeparator ?? "0")",
                    incomes: "\("tenge".localized) \(cardModel?.incomes.formattedWithSeparator ?? "0")"
                )
                
                self?.view?.reloadTransactionTableView()
            case .failure(let failure):
                self?.view?.showFailure(with: failure)
            }
        }
    }
}
