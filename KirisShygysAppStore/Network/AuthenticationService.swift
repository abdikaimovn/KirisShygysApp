//
//  AuthenticationService.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//
import FirebaseAuth
import FirebaseFirestore

final class AuthenticationService {
    func authorizeUser(with userData: AuthorizationModel,
                       completion: @escaping (Result<(), NetworkErrorModel>) -> Void) {
        let email = userData.email
        let password = userData.password
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(self.handleError(with: error)))
                return
            } else {
                completion(.success(()))
            }
        }
    }
    
    func registerUser(with userData: RegistrationModel,
                      completion: @escaping (Result<(), NetworkErrorModel>) -> Void) {
        let username = userData.name
        let email = userData.email
        let password = userData.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(self.handleError(with: error)))
                return
            } else {
                guard let userResult = result?.user else {
                    completion(.failure(NetworkErrorModel(
                        title: "unknown_error_title".localized,
                        error: nil,
                        text: nil,
                        description: "unknown_error".localized)))
                    return
                }
                
                let db = Firestore.firestore()
                db.collection(FirebaseDocumentName.users.rawValue)
                    .document(userResult.uid)
                    .setData([
                        "username": username,
                        "email": email
                    ]) { error in
                        if let error = error {
                            completion(.failure(
                                NetworkErrorModel(
                                    title: "unknown_error_title".localized,
                                    error: error,
                                    text: error.localizedDescription,
                                    description: "unknown_error".localized)))
                            return
                        }
                        
                        completion(.success(()))
                    }
            }
        }
    }
    
    private func handleError(with error: Error) -> NetworkErrorModel {
        let errorCode = AuthErrorCode(_nsError: error as NSError)
        switch errorCode.code {
        case .emailAlreadyInUse:
            return NetworkErrorModel(title: "registration_error_title".localized,
                              error: error,
                              text: error.localizedDescription,
                              description: "credentialAlreadyInUse_error".localized)
        case .networkError:
            return NetworkErrorModel(
                title: "network_error_title".localized,
                error: error,
                text: error.localizedDescription,
                description: "network_error".localized)
        case .invalidCredential:
            return NetworkErrorModel(
                title: "authorization_error".localized,
                error: error,
                text: error.localizedDescription,
                description: "invalidCredential_error".localized)
        default:
            return NetworkErrorModel(
                title: "unknown_error_title",
                error: error,
                text: error.localizedDescription,
                description: "unknown_error".localized)
        }
    }
}
