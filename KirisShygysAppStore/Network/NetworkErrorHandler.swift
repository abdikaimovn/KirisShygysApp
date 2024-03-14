//
//  ErrorHandler.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 25.02.2024.
//
import FirebaseAuth

final class NetworkErrorHandler {
    static var shared = NetworkErrorHandler()
    
    private init() {}
    
    func handleError(error: Error) -> NetworkErrorModel {
        let errorCode = AuthErrorCode(_nsError: error as NSError)
        switch errorCode.code {
        case .unverifiedEmail:
            return NetworkErrorModel(
                title: "registration_error_title".localized,
                error: error,
                text: error.localizedDescription,
                description: "credentialAlreadyInUse_error".localized)
        case .emailAlreadyInUse:
            return NetworkErrorModel(
                title: "registration_error_title".localized,
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
                title: "authorization_error_title".localized,
                error: error,
                text: error.localizedDescription,
                description: "invalidCredential_error".localized)
        case .userNotFound:
            return NetworkErrorModel(
                title: "network_error_title".localized,
                error: error,
                text: error.localizedDescription,
                description: "userNotFound_error".localized)
        default:
            return NetworkErrorModel(
                title: "unknown_error_title".localized,
                error: error,
                text: error.localizedDescription,
                description: "unknown_error".localized)
        }
    }
    
    var unknownError: NetworkErrorModel {
        NetworkErrorModel(
            title: "unknown_error_title".localized,
            error: nil,
            text: nil,
            description: "unknown_error".localized)
    }
    
    var documentFetchingError: NetworkErrorModel {
        NetworkErrorModel(
            title: "error_title".localized,
            error: nil,
            text: nil,
            description: "documentFetching_error".localized)
    }
    
    var usernameFetchingError: NetworkErrorModel {
        NetworkErrorModel(
            title: "error_title".localized,
            error: nil,
            text: nil,
            description: "usernameFetching_error".localized)
    }
    
    var transactionDeletingError: NetworkErrorModel {
        NetworkErrorModel(
            title: "error_title".localized,
            error: nil,
            text: nil,
            description: "transactionDeleting_error".localized)
    }
    
    var notVerifiedEmail: NetworkErrorModel {
        NetworkErrorModel(
            title: "verificationError_title".localized,
            error: nil,
            text: nil,
            description: "notVerifiedEmail_error".localized)
    }
    
    var notExistedEmail: NetworkErrorModel {
        NetworkErrorModel(
            title: "error_title".localized,
            error: nil,
            text: nil,
            description: "emailNotFound_error".localized)
    }
    
    var networkError: NetworkErrorModel {
        NetworkErrorModel(
                title: "network_error_title".localized,
                error: nil,
                text: nil,
                description: "network_error".localized)
    }
}
