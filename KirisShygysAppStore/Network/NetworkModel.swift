//
//  NetworkModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

struct NetworkErrorModel: Error {
    let title: String
    let error: Error?
    let text: String?
    let description: String
}

struct ErrorHandler {
    static func handleError(_ errorType: ErrorType) -> ErrorModel {
        switch errorType {
        case .reportLackData:
            return ErrorModel(
                title: "lackDataAlert_title".localized,
                description: "reportLackDataAlert_message".localized)
        case .historyLackData:
            return ErrorModel(
                title: "lackDataAlert_title".localized,
                description: "historyLackDataAlert_message".localized)
        case .statisticsLackData:
            return ErrorModel(
                title: "lackDataAlert_title".localized,
                description: "statisticsLackDataAlert_message".localized)
        }
    }
}

struct ErrorModel {
    let title: String
    let description: String
}

enum ErrorType {
    case reportLackData
    case historyLackData
    case statisticsLackData
}

enum FirebaseDocumentName: String {
    case users = "users"
    case transactions = "Transactions"
    case incomes = "Incomes"
    case expenses = "Expenses"
    case username = "username"
}
