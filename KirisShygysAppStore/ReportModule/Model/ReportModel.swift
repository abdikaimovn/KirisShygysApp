//
//  ReportModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 23.02.2024.
//

struct ReportModel {
    let transactionType: String
    let amount: String
    let biggestTransactionLabel: String
    let biggestTransactionName: String
    let biggestTransactionAmount: String
    let isEmptyAmount: Bool
}

struct QuoteModel {
    let quote: String
    let author: String
}

struct ReportInfo {
    let summa: Int
    let maxValue: Int
    let maxValueTitle: String
    let isEmptyAmount: Bool
}
