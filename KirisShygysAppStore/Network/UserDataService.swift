//
//  UserDataService.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 13.02.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol TransactionServiceProtocol {
    func insertNewTransaction(transaction: ValidatedTransactionModel, completion: @escaping (Result<(), NetworkErrorModel>) -> ())
}

protocol HomeServiceProtocol {
    func fetchUsername(completion: @escaping (Result<String, NetworkErrorModel>) -> ())
    func fetchTransactionsData(completion: @escaping (Result<[ValidatedTransactionModel], NetworkErrorModel>) -> ())
}

struct UserDataService {
    
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

extension UserDataService: HomeServiceProtocol {
    func fetchUsername(completion: @escaping (Result<String, NetworkErrorModel>) -> ()) {
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
        
        let ref = Firestore.firestore().collection(FirebaseDocumentName.users.rawValue).document(currentUserUID)
        
        ref.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(
                    NetworkErrorModel(
                        title: "error_title".localized,
                        error: error,
                        text: error.localizedDescription,
                        description: "usernameFetching_error".localized)
                ))
            }
            
            if let snapshot = snapshot, let userData = snapshot.data(), let name = userData[FirebaseDocumentName.username.rawValue] as? String {
                completion(.success(name))
            }
        }
        
    }
    
    func fetchTransactionsData(completion: @escaping (Result<[ValidatedTransactionModel], NetworkErrorModel>) -> ()) {
        let db = Firestore.firestore()
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
        
        db.collection(FirebaseDocumentName.users.rawValue)
            .document(currentUserUID)
            .collection(FirebaseDocumentName.transactions.rawValue)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(
                        NetworkErrorModel(
                            title: "error_title".localized,
                            error: error,
                            text: error.localizedDescription,
                            description: "documentFetching_error".localized)
                    ))
                    return
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
                    
                    let transactions = querySnapshot?.documents.compactMap { document in
                        return ValidatedTransactionModel(data: document.data())
                    } ?? []
                    
                    let sortedTransactionData = transactions.sorted{ (transaction1: ValidatedTransactionModel, transaction2: ValidatedTransactionModel) -> Bool in
                        if let date1 = dateFormatter.date(from: transaction1.transactionDate), let date2 = dateFormatter.date(from: transaction2.transactionDate) {
                            return date1 > date2
                        }
                        return false
                    }

                    completion(.success(sortedTransactionData))
                }
            }
    }
}
