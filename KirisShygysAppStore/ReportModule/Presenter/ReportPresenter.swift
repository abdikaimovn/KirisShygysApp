//
//  ReportPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 23.02.2024.
//

import UIKit
import Foundation

protocol ReportViewProtocol: AnyObject {
    func updateViewAppereance(with color: UIColor)
}

final class ReportPresenter {
    weak var view: ReportViewProtocol?
    private let transactionsData: [ValidatedTransactionModel]
    
    private var reportData: [ReportModel] = []
    
    init(transactionsData: [ValidatedTransactionModel]) {
        self.transactionsData = transactionsData
        calculateReportData(data: transactionsData)
    }
    
    private func calculateReportData(data: [ValidatedTransactionModel]) {
        var incomeSum = 0
        var expenseSum = 0
        var maxIncome = 0
        var maxExpense = 0
        var maxIncomeTitle = "none_label".localized
        var maxExpenseTitle = "none_label".localized
        
        for transaction in data {
            if transaction.transactionType == .income {
                incomeSum += transaction.transactionAmount
                if maxIncome < transaction.transactionAmount {
                    maxIncome = transaction.transactionAmount
                    maxIncomeTitle = transaction.transactionName
                }
            } else {
                expenseSum += transaction.transactionAmount
                if maxExpense < transaction.transactionAmount {
                    maxExpense = transaction.transactionAmount
                    maxExpenseTitle = transaction.transactionName
                }
            }
        }
        
        let isEmptyIncomeAmount = incomeSum == 0
        let isEmptyExpenseAmount = expenseSum == 0
        
        let reportModel = [
            ReportModel(
                transactionType: "spend_label".localized,
                amount: "\("currency".localized) \(expenseSum)",
                biggestTransactionLabel: "biggestSpending_label".localized,
                biggestTransactionName: maxExpenseTitle,
                biggestTransactionAmount: "\("currency".localized) \(maxExpense)",
                isEmptyAmount: isEmptyExpenseAmount),
            ReportModel(
                transactionType: "earn_label".localized,
                amount: "\("currency".localized) \(incomeSum)",
                biggestTransactionLabel: "biggentEarning_label".localized,
                biggestTransactionName: maxIncomeTitle,
                biggestTransactionAmount: "\("currency".localized) \(maxIncome)",
                isEmptyAmount: isEmptyIncomeAmount)
        ]
        
        reportData = reportModel
    }
    
    func numberOfItemsInSection() -> Int {
        3
    }
    
    func dataForItem(at indexPath: IndexPath) -> ReportModel {
        return reportData[indexPath.row]
    }
    
    func pageControlDidChange(_ index: Int) {
        switch index {
        case 0:
            view?.updateViewAppereance(with: .expenseColor)
        case 1:
            view?.updateViewAppereance(with: .incomeColor)
        case 2:
            view?.updateViewAppereance(with: .brownColor)
        default:
            break
        }
    }
}
