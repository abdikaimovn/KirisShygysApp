//
//  NetworkModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 26.01.2024.
//

struct NetworkErrorModel: Error {
    let title: String
    let error: Error?
    let text: String?
    let description: String
}

enum FirebaseDocumentName: String {
    case users = "users"
    case transactions = "Transactions"
    case incomes = "Incomes"
    case expenses = "Expenses"
    case username = "username"
}
