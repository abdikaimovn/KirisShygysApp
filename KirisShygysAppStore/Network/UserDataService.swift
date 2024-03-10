//
//  UserDataService.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 13.02.2024.
//

import Firebase
import FirebaseFirestore

//MARK: - SERVICE PROTOCOLS
protocol TransactionServiceProtocol {
    func insertNewTransaction(transaction: ValidatedTransactionModel, completion: @escaping (Result<(), NetworkErrorModel>) -> ())
}

protocol HomeServiceProtocol {
    func fetchUsername(completion: @escaping (Result<String, NetworkErrorModel>) -> ())
    func fetchTransactionsData(completion: @escaping (Result<[ValidatedTransactionModel], NetworkErrorModel>) -> ())
}

protocol HistoryServiceProtocol {
    func deleteTransaction(transactionData: ValidatedTransactionModel, completion: @escaping (Result<(), NetworkErrorModel>) -> ())
}

protocol ServicesDataManagerProtocol {
    func fetchLastMonthTransactionData(completion: @escaping (Result<[ValidatedTransactionModel], NetworkErrorModel>) -> ())
    func removeAllHistoryData(completion: @escaping (Result<(), NetworkErrorModel>) -> ())
}

protocol PersonalInfoService {
    func fetchUsername(completion: @escaping (Result<String, NetworkErrorModel>) -> ())
    func fetchUserEmail(completion: (Result<String, NetworkErrorModel>) -> ())
}

//MARK: - SERVICE
struct UserDataService {
    private let database = Firestore.firestore()
    
    private var userUID: String? {
        Auth.auth().currentUser?.uid
    }
    
    private func deleteCollection(_ collectionRef: CollectionReference, completion: @escaping (Result<(), NetworkErrorModel>) -> ()) {
        collectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                return
            }
            
            guard let snapshot = snapshot else {
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            for document in snapshot.documents {
                dispatchGroup.enter()
                collectionRef.document(document.documentID).delete { error in
                    if let error = error {
                        completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                    }
                    dispatchGroup.leave()
                }
            }
            
            completion(.success(()))
        }
    }
    
    func fetchUsername(completion: @escaping (Result<String, NetworkErrorModel>) -> ()) {
        guard let currentUserUID = userUID else {
            completion(.failure(NetworkErrorHandler.shared.unknownError))
            return
        }
        
        let reference = Firestore.firestore().collection(FirebaseDocumentName.users.rawValue).document(currentUserUID)
        
        reference.getDocument { snapshot, error in
            if error != nil {
                completion(.failure(NetworkErrorHandler.shared.usernameFetchingError))
                return
            }
            
            if let snapshot = snapshot, let userData = snapshot.data(), let name = userData[FirebaseDocumentName.username.rawValue] as? String {
                completion(.success(name))
            }
        }
        
    }
}

//MARK: - EXTENSIONS
extension UserDataService: TransactionServiceProtocol {
    func insertNewTransaction(transaction: ValidatedTransactionModel, completion: @escaping (Result<(), NetworkErrorModel>) -> ()) {
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
        
        guard let currentUserUID = userUID else {
            completion(.failure(NetworkErrorHandler.shared.unknownError))
            return
        }
        
        // Добаление транзакции в коллекцию "Incomes" или "Expenses"
        database.collection(FirebaseDocumentName.users.rawValue)
            .document(currentUserUID)
            .collection(collectionName)
            .document(transactionId)
            .setData(transactionDataDict) { error in
                if let error = error {
                    completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                    return
                }
            }
        
        // Добавления транзакции в коллекцию "Transactions"
        database.collection(FirebaseDocumentName.users.rawValue)
            .document(currentUserUID)
            .collection(FirebaseDocumentName.transactions.rawValue)
            .document(transactionId)
            .setData(transactionDataDict) { error in
                if let error = error {
                    completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                    return
                }
            }
        
        completion(.success(()))
    }
}

extension UserDataService: HomeServiceProtocol {
    func fetchTransactionsData(completion: @escaping (Result<[ValidatedTransactionModel], NetworkErrorModel>) -> ()) {
        guard let currentUserUID = userUID else {
            completion(.failure(NetworkErrorHandler.shared.unknownError))
            return
        }
        
        database.collection(FirebaseDocumentName.users.rawValue)
            .document(currentUserUID)
            .collection(FirebaseDocumentName.transactions.rawValue)
            .getDocuments { (querySnapshot, error) in
                if error != nil {
                    completion(.failure(NetworkErrorHandler.shared.documentFetchingError))
                    return
                }
                
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

extension UserDataService: HistoryServiceProtocol {
    func deleteTransaction(transactionData: ValidatedTransactionModel, completion: @escaping (Result<(), NetworkErrorModel>) -> ()) {
        let collectionName: String
        switch transactionData.transactionType {
        case .income:
            collectionName = "Incomes"
        case .expense:
            collectionName = "Expenses"
        }
        
        guard let transactionId = transactionData.id else {
            return
        }
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(.failure(NetworkErrorHandler.shared.unknownError))
            return
        }
        
        // Удаление транзакции из коллекции "Incomes" или "Expenses"
        database.collection(FirebaseDocumentName.users.rawValue)
            .document(currentUserUID)
            .collection(collectionName)
            .document(transactionId)
            .delete { error in
                if error != nil {
                    completion(.failure(NetworkErrorHandler.shared.transactionDeletingError))
                    return
                }
            }
        
        // Удаление транзакции из коллекции "Transactions"
        database.collection(FirebaseDocumentName.users.rawValue)
            .document(currentUserUID)
            .collection(FirebaseDocumentName.transactions.rawValue)
            .document(transactionId)
            .delete { error in
                if error != nil {
                    completion(.failure(NetworkErrorHandler.shared.transactionDeletingError))
                    return
                }
            }
        
        completion(.success(()))
    }
}

extension UserDataService: ServicesDataManagerProtocol {
    func removeAllHistoryData(completion: @escaping (Result<(), NetworkErrorModel>) -> ()) {
        guard let currentUserUID = userUID else {
            completion(.failure(NetworkErrorHandler.shared.unknownError))
            return
        }
        
        let incomesCollectionRef = database.collection(FirebaseDocumentName.users.rawValue).document(currentUserUID).collection(FirebaseDocumentName.incomes.rawValue)
        let expensesCollectionRef = database.collection(FirebaseDocumentName.users.rawValue).document(currentUserUID).collection(FirebaseDocumentName.expenses.rawValue)
        let transactionsCollectionRef = database.collection(FirebaseDocumentName.users.rawValue).document(currentUserUID).collection(FirebaseDocumentName.transactions.rawValue)
        
        // Use DispatchGroup to wait for all deletions to complete
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        deleteCollection(incomesCollectionRef) { result in
            switch result {
            case .success(_):
                dispatchGroup.leave()
            case .failure(let failure):
                completion(.failure(failure))
                return
            }
        }
        
        dispatchGroup.enter()
        deleteCollection(expensesCollectionRef) { result in
            switch result {
            case .success(_):
                dispatchGroup.leave()
            case .failure(let failure):
                completion(.failure(failure))
                return
            }
        }
        
        dispatchGroup.enter()
        deleteCollection(transactionsCollectionRef) { result in
            switch result {
            case .success(_):
                dispatchGroup.leave()
            case .failure(let failure):
                completion(.failure(failure))
                return
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    func fetchLastMonthTransactionData(completion: @escaping (Result<[ValidatedTransactionModel], NetworkErrorModel>) -> ()) {
        //Check if user is registered
        guard let currentUserUID = userUID else {
            completion(.failure(NetworkErrorHandler.shared.unknownError))
            return
        }
        
        // Calculate the start and end date for the last month
        let currentDate = Date()
        let lastMonthStartDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        let lastMonthEndDate = currentDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        database.collection(FirebaseDocumentName.users.rawValue).document(currentUserUID).collection(FirebaseDocumentName.transactions.rawValue)
            .getDocuments { (querySnapshot, error) in
                if error != nil {
                    completion(.failure(NetworkErrorHandler.shared.documentFetchingError))
                    return
                } else {
                    let transactions = querySnapshot?.documents.compactMap { document in
                        return ValidatedTransactionModel(data: document.data())
                    } ?? []
                    
                    //Sort data in descending order
                    let transactionData = transactions.sorted { (transaction1, transaction2) in
                        if let date1 = dateFormatter.date(from: transaction1.transactionDate),
                           let date2 = dateFormatter.date(from: transaction2.transactionDate) {
                            return date1 > date2
                        }
                        return false
                    }
                    
                    let lastMonthTransactions = transactionData.filter { transaction in
                        if let date = dateFormatter.date(from: transaction.transactionDate) {
                            return date >= lastMonthStartDate && date <= lastMonthEndDate
                        }
                        return false
                    }
                    
                    completion(.success(lastMonthTransactions))
                }
            }
    }
}

extension UserDataService: PersonalInfoService {
    func fetchUserEmail(completion: (Result<String, NetworkErrorModel>) -> ()) {
        if let email = AuthenticationService.user?.email {
            completion(.success(email))
        } else {
            completion(.failure(NetworkErrorHandler.shared.unknownError))
        }
    }
}
