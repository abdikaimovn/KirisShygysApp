//
//  TransactionPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 13.02.2024.
//

import Foundation

protocol TransactionViewProtocol: AnyObject {
    func showInvalidAmountAlert()
    func showInvalidNameAlert()
    func showFailure(with error: NetworkErrorModel)
    func showSuccess()
    func updateAppereanceWithIncomeColor()
    func updateAppereanceWithExpenseColor()
}

final class TransactionPresenter {
    weak var view: TransactionViewProtocol?
    private let networkService: TransactionServiceProtocol
    
    init(networkService: TransactionServiceProtocol) {
        self.networkService = networkService
    }
    
    func saveTransactionDidTapped(with model: TransactionModel) {
        guard let validAmount = model.transactionAmount, validAmount != 0 else {
            view?.showInvalidAmountAlert()
            return
        }
        
        guard let validName = model.transactionName, !validName.isEmpty else {
            view?.showInvalidNameAlert()
            return
        }
        
        let description = model.transactionDescription
        let transactionType = model.transactionType
        let date = model.transactionDate ?? ""
        
        let data = ValidatedTransactionModel(
            amount: validAmount,
            type: transactionType,
            name: validName,
            description: description ?? "",
            date: date
        )
        
        networkService.insertNewTransaction(transaction: data) { [weak self] result in
            switch result {
            case .success():
                self?.view?.showSuccess()
            case .failure(let error):
                self?.view?.showFailure(with: error)
            }
        }
    }
    
    func segmentedControlChosen(index: Int) {
        if index == 0 {
            view?.updateAppereanceWithIncomeColor()
        } else {
            view?.updateAppereanceWithExpenseColor()
        }
    }
}
