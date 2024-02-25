//
//  AuthenticationService.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//
import FirebaseAuth
import FirebaseFirestore

protocol RegistrationNetworkService {
    func registerUser(with userData: RegistrationModel,
                      completion: @escaping (Result<(), NetworkErrorModel>) -> Void)
}

protocol AuthorizationNetworkService {
    func authorizeUser(with userData: AuthorizationModel,
                       completion: @escaping (Result<(), NetworkErrorModel>) -> Void)
}

protocol ServicesAuthenticationProtocol {
    func logOut(completion: @escaping (Result<(), NetworkErrorModel>) -> ())
}

struct AuthenticationService {
    static var user: User? {
        Auth.auth().currentUser
    }
}

extension AuthenticationService: RegistrationNetworkService {
    private func setUserToDB(
        with uid: String,
        username: String,
        email: String,
        completion: @escaping ((Result<(), NetworkErrorModel>) -> ())) {
            let db = Firestore.firestore()
            db.collection(FirebaseDocumentName.users.rawValue)
                .document(uid)
                .setData([
                    "username": username,
                    "email": email
                ]) { error in
                    if let error = error {
                        completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                        return
                    }
                    
                    completion(.success(()))
                }
    }
    
    func registerUser(with userData: RegistrationModel,
                      completion: @escaping (Result<(), NetworkErrorModel>) -> Void) {
        let username = userData.name ?? ""
        let email = userData.email ?? ""
        let password = userData.password ?? ""
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                return
            }
            
            guard let userResult = result?.user else {
                completion(.failure(NetworkErrorHandler.shared.unknownError))
                return
            } 
            
            setUserToDB(with: userResult.uid, username: username, email: email, completion: completion)
        }
    }
}

extension AuthenticationService: AuthorizationNetworkService {
    func authorizeUser(with userData: AuthorizationModel,
                       completion: @escaping (Result<(), NetworkErrorModel>) -> Void) {
        let email = userData.email ?? ""
        let password = userData.password ?? ""

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                return
            }
            
            completion(.success(()))
        }
    }
}

extension AuthenticationService: ServicesAuthenticationProtocol {
    func logOut(completion: @escaping (Result<(), NetworkErrorModel>) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
            return
        }
    }
}
