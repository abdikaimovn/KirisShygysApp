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
    func setTransactionData(data: [ValidatedTransactionModel])
    func showFailure(with error: NetworkErrorModel)
}

final class HomePresenter {
    weak var view: HomeViewProtocol?
    private let networkService: HomeServiceProtocol
    
    init(networkService: HomeServiceProtocol) {
        self.networkService = networkService
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
                let cardModel = self?.calculateCardValues(data: transactionData)
                
                self?.view?.setCardValues(
                    total: "\("currency".localized) \(cardModel?.total ?? 0)",
                    expenses: "\("currency".localized) \(cardModel?.expenses ?? 0)",
                    incomes: "\("currency".localized) \(cardModel?.incomes ?? 0)"
                )
                
                self?.view?.setTransactionData(data: transactionData)
            case .failure(let failure):
                self?.view?.showFailure(with: failure)
            }
        }
    }
}
