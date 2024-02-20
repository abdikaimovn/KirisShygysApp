//
//  HistoryModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 19.02.2024.
//

import Foundation

struct SectionTitleModel {
    var fullDate: String
    
    var sectionTitleDate: String {
        return String(fullDate.prefix(10))
    }
}

struct TransactionFilter {
    func applySortBy(sortBy: SortByEnum, transactionData: [ValidatedTransactionModel]) -> [ValidatedTransactionModel] {
        switch sortBy {
        case .newest:
            return transactionData
        case .oldest:
            return transactionData.reversed()
        }
    }
    
    func applyTransactionsByPeriod(
        period: PeriodEnum,
        transactionData: [ValidatedTransactionModel]) -> [ValidatedTransactionModel] 
    {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            // Function to check if a transaction falls within the specified period
            func isTransactionInPeriod(_ transaction: ValidatedTransactionModel, periodStartDate: Date, periodEndDate: Date) -> Bool {
                guard let transactionDate = dateFormatter.date(from: String(transaction.transactionDate.prefix(10))) else {
                    return false
                }
                return transactionDate >= periodStartDate && transactionDate <= periodEndDate
            }
            
            // Filter transactions based on the specified period
            var filteredTransactions: [ValidatedTransactionModel]
            
            let currentDate = Date()
            var periodStartDate: Date
            var periodEndDate: Date
            
            switch period {
            case .week:
                periodStartDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate) ?? currentDate
            case .month:
                periodStartDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
            case .halfyear:
                periodStartDate = Calendar.current.date(byAdding: .month, value: -6, to: currentDate) ?? currentDate
            case .year:
                periodStartDate = Calendar.current.date(byAdding: .year, value: -1, to: currentDate) ?? currentDate
            }
            
            periodEndDate = currentDate
            
            filteredTransactions = transactionData.filter { isTransactionInPeriod($0, periodStartDate: periodStartDate, periodEndDate: periodEndDate) }
            
            return filteredTransactions
        }
    
    func applyFilterBy( filterBy: TransactionType, transactionData: [ValidatedTransactionModel]) -> [ValidatedTransactionModel] {
        transactionData.filter { $0.transactionType == filterBy }
    }
}

