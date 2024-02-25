//
//  ErrorModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 25.02.2024.
//

struct ErrorModel {
    let title: String
    let description: String
}

extension ErrorModel {
    static var reportLackData: ErrorModel {
        ErrorModel(
            title: "lackDataAlert_title".localized,
            description: "reportLackDataAlert_message".localized)
    }
    
    static var historyLackData: ErrorModel {
        ErrorModel(
            title: "lackDataAlert_title".localized,
            description: "historyLackDataAlert_message".localized)
    }
    
    static var statisticsLackData: ErrorModel {
        ErrorModel(
            title: "lackDataAlert_title".localized,
            description: "statisticsLackDataAlert_message".localized)
    }
}
