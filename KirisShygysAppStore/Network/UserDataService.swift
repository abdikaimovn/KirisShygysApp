//
//  UserDataService.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 13.02.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol TransactionServiceProtocol: AnyObject {
    func insertNewTransaction(transaction: ValidatedTransactionModel, completion: @escaping (Result<(), NetworkErrorModel>) -> ())
}

final class UserDataService {
    
}

extension UserDataService: TransactionServiceProtocol {
    func insertNewTransaction(transaction: ValidatedTransactionModel, completion: @escaping (Result<(), NetworkErrorModel>) -> ()) {
        let db = Firestore.firestore()
        
        let collectionName: String
        switch transaction.transactionType {
        case .income:
            collectionName = "Incomes"
        case .expense:
            collectionName = "Expenses"
        }
        
        // Уникальный id для транзакций
        let transactionId = UUID().uuidString
        
        // Создание словаря для данных транзакции
        let transactionDataDict: [String: Any] = [
            "id": transactionId,
            "name": transaction.transactionName,
            "type": collectionName,
            "description": transaction.transactionDescription,
            "amount": transaction.transactionAmount,
            "date": transaction.transactionDate
        ]
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(.failure(
                NetworkErrorModel(
                    title: "unknown_error_title".localized,
                    error: nil,
                    text: nil,
                    description: "unknown_error".localized)
            ))
            return
        }
        
        // Добаление транзакции в коллекцию "Incomes" или "Expenses"
        db.collection(FirebaseDocumentName.users.rawValue)
            .document(currentUserUID)
            .collection(collectionName)
            .document(transactionId)
            .setData(transactionDataDict) { error in
                if let error = error {
                    completion(.failure(
                        NetworkErrorModel(
                            title: "unknown_error_title".localized,
                            error: error,
                            text: error.localizedDescription,
                            description: "unknown_error".localized)
                    ))
                    return
                }
            }
        
        // Добавления транзакции в коллекцию "Transactions"
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection(FirebaseDocumentName.transactions.rawValue)
            .document(transactionId)
            .setData(transactionDataDict) { error in
                if let error = error {
                    completion(.failure(
                        NetworkErrorModel(
                            title: "unknown_error_title".localized,
                            error: error,
                            text: error.localizedDescription,
                            description: "unknown_error".localized)
                    ))
                    return
                }
            }
        
        completion(.success(()))
    }
}
