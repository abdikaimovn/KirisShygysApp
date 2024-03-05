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
        let (incomeSum, maxIncome, maxIncomeTitle) = data.filter { $0.transactionType == .income }
            .reduce(into: (0, 0, "none_label".localized)) { result, transaction in
                result.0 += transaction.transactionAmount // Increment incomeSum
                if transaction.transactionAmount > result.1 {
                    result.1 = transaction.transactionAmount // Update maxIncome
                    result.2 = transaction.transactionName // Update maxIncomeTitle
                }
        }

        let (expenseSum, maxExpense, maxExpenseTitle) = data.filter { $0.transactionType == .expense }
            .reduce(into: (0, 0, "none_label".localized)) { result, transaction in
                result.0 += transaction.transactionAmount // Increment expenseSum
                if transaction.transactionAmount > result.1 {
                    result.1 = transaction.transactionAmount // Update maxExpense
                    result.2 = transaction.transactionName // Update maxExpenseTitle
                }
        }

        
        let isEmptyIncomeAmount = incomeSum == 0
        let isEmptyExpenseAmount = expenseSum == 0
        
        let reportModel = [
            ReportModel(
                transactionType: "spend_label".localized,
                amount: "\("tenge".localized) \(expenseSum.formattedWithSeparator)",
                biggestTransactionLabel: "biggestSpending_label".localized,
                biggestTransactionName: maxExpenseTitle,
                biggestTransactionAmount: "\("tenge".localized) \(maxExpense.formattedWithSeparator)",
                isEmptyAmount: isEmptyExpenseAmount),
            ReportModel(
                transactionType: "earn_label".localized,
                amount: "\("tenge".localized) \(incomeSum.formattedWithSeparator)",
                biggestTransactionLabel: "biggentEarning_label".localized,
                biggestTransactionName: maxIncomeTitle,
                biggestTransactionAmount: "\("tenge".localized) \(maxIncome.formattedWithSeparator)",
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
