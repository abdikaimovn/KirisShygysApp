//
//  TransactionModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 13.02.2024.
//

import Foundation

struct TransactionModel {
    var id: String?
    var transactionAmount: Double?
    var transactionType: TransactionType
    var transactionName: String?
    var transactionDescription: String?
    var transactionDate: String?

    // Инициализатор для преобразования данных из Firebase
    init(data: [String: Any]) {
        id = data["id"] as? String
        transactionAmount = data["amount"] as? Double
        transactionType = TransactionType(rawValue: data["type"] as? String ?? "") ?? .income
        transactionName = data["name"] as? String
        transactionDescription = data["description"] as? String
        transactionDate = data["date"] as? String
    }

    // Инициализатор для создания объекта из явных параметров
    init(amount: Double?, type: TransactionType, name: String?, description: String?, date: String?) {
        transactionAmount = amount
        transactionType = type
        transactionName = name
        transactionDescription = description
        transactionDate = date
    }
}

struct ValidatedTransactionModel {
    var id: String?
    var transactionAmount: Double
    var transactionType: TransactionType
    var transactionName: String
    var transactionDescription: String
    var transactionDate: String
}

enum TransactionType: String {
    case income = "Incomes"
    case expense = "Expenses"
}
