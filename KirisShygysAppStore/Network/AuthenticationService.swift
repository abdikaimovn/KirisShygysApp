//
//  AuthenticationService.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

import FirebaseFirestore
import FirebaseAuth
import Firebase

protocol RegistrationNetworkService {
    func registerUser(with userData: RegistrationModel,
                      completion: @escaping (Result<(), NetworkErrorModel>) -> Void)
    func logOut()
}

protocol AuthorizationNetworkService {
    func authorizeUser(with userData: AuthorizationModel,
                       completion: @escaping (Result<(), NetworkErrorModel>) -> Void)
    func resetPassword(with email: String, completion: @escaping (Result<(), NetworkErrorModel>) -> ())
}

protocol ServicesAuthenticationProtocol {
    func logOut(completion: @escaping (Result<(), NetworkErrorModel>) -> ())
    func changeUserPassword(with password: PasswordModel, completion: @escaping (Result<(), NetworkErrorModel>) -> ())
    func passwordDidChange()
    func deleteUser(completion: @escaping (Result<(), NetworkErrorModel>) -> ())
}

struct AuthenticationService {
    private let dataBase = Firestore.firestore()
    
    static var user: User? {
        Auth.auth().currentUser
    }
    
    static func sendEmailVerificationLink() {
        AuthenticationService.user?.sendEmailVerification()
    }
    
    static func checkEmailVerification() -> Bool {
        AuthenticationService.user?.isEmailVerified ?? false
    }
}

extension AuthenticationService: RegistrationNetworkService {
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch _ {
            return
        }
    }
    
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
        let email = userData.email?.lowercased() ?? ""
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
    func resetPassword(with email: String, completion: @escaping (Result<(), NetworkErrorModel>) -> ()) {
        let usersRef = Firestore.firestore().collection(FirebaseDocumentName.users.rawValue)
        
        usersRef.whereField(FirebaseDocumentName.email.rawValue, isEqualTo: email).getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                completion(.failure(NetworkErrorHandler.shared.handleError(error: error ?? NSError())))
                return
            }
            
            if snapshot.isEmpty {
                completion(.failure(NetworkErrorHandler.shared.notExistedEmail))
                return
            }
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                    return
                }
                
                completion(.success(()))
            }
        }
    }
    
    func authorizeUser(with userData: AuthorizationModel,
                       completion: @escaping (Result<(), NetworkErrorModel>) -> Void) {
        let email = userData.email ?? ""
        let password = userData.password ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                return
            }
            
            if AuthenticationService.checkEmailVerification() {
                completion(.success(()))
            } else {
                completion(.failure(NetworkErrorHandler.shared.notVerifiedEmail))
                logOut()
            }
        }
    }
}

extension AuthenticationService: ServicesAuthenticationProtocol {
    func deleteUser(completion: @escaping (Result<(), NetworkErrorModel>) -> ()) {
        guard let email = AuthenticationService.user?.email else {
            return
        }
        
        let query = dataBase.collection(FirebaseDocumentName.users.rawValue).whereField(FirebaseDocumentName.email.rawValue, isEqualTo: email)
        
        query.getDocuments { snapshot, error in
            if let error {
                completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                return
            }
            
            guard let snapshot, !snapshot.isEmpty else {
                completion(.failure(NetworkErrorHandler.shared.notExistedEmail))
                return
            }
            
            let document = snapshot.documents.first!
            
            document.reference.delete { error in
                if let error = error {
                    completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                    return
                }
                
                AuthenticationService.user?.delete(completion: { error in
                    if let error {
                        completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                    }
                    
                    completion(.success(()))
                })
            }
        }
    }
    
    func passwordDidChange() {
        logOut()
    }
    
    func changeUserPassword(with password: PasswordModel, completion: @escaping (Result<(), NetworkErrorModel>) -> ()) {
        guard let currentEmail = AuthenticationService.user?.email else {
            return
        }
        
        guard let oldPassword = password.oldPassword else {
            return
        }
        
        guard let newPassword = password.newPassword else {
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: oldPassword)
        
        AuthenticationService.user?.reauthenticate(with: credential, completion: { _, error in
            if let error {
                completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                return
            }
            
            AuthenticationService.user?.updatePassword(to: newPassword, completion: { error in
                if let error {
                    completion(.failure(NetworkErrorHandler.shared.handleError(error: error)))
                }
                
                completion(.success(()))
            })
        })
    }
    
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
