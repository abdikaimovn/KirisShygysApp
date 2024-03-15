//
//  TransactionModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 13.02.2024.
//

import Foundation

struct TransactionModel {
    let id: String?
    let transactionAmount: Int?
    let transactionType: TransactionType
    let transactionName: String?
    let transactionDescription: String?
    let transactionDate: String?
    
    init(amount: Int?, type: TransactionType, name: String?, description: String?, date: String?) {
        id = nil
        transactionAmount = amount
        transactionType = type
        transactionName = name
        transactionDescription = description
        transactionDate = date
    }
}

struct ValidatedTransactionModel: Identifiable {
    let id: String?
    let transactionAmount: Int
    let transactionType: TransactionType
    let transactionName: String
    let transactionDescription: String
    let transactionDate: String
    
    // Инициализатор для преобразования данных из Firebase
    init(data: [String: Any]) {
        id = data["id"] as? String
        transactionAmount = data["amount"] as? Int ?? 0
        transactionType = TransactionType(rawValue: data["type"] as? String ?? "") ?? .income
        transactionName = data["name"] as? String ?? ""
        transactionDescription = data["description"] as? String ?? ""
        transactionDate = data["date"] as? String ?? ""
    }

    // Инициализатор для создания объекта из явных параметров
    init(amount: Int, type: TransactionType, name: String, description: String, date: String) {
        id = nil
        transactionAmount = amount
        transactionType = type
        transactionName = name
        transactionDescription = description
        transactionDate = date
    }
}

enum TransactionType: String {
    case income = "Incomes"
    case expense = "Expenses"
}
