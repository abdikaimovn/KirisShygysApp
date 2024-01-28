//
//  AuthorizationPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

protocol AuthorizationViewProtocol: AnyObject{
    func showInvalidEmailError()
    func showInvalidPasswordError()
    func showHomeView()
    func showAuthorizationError(with error: NetworkErrorModel)
    func showLoader()
    func hideLoader()
}

final class AuthorizationPresenter {
    weak var view: AuthorizationViewProtocol?
    private let authorizationService: AuthorizationNetworkService
    
    init(authorizationService: AuthorizationNetworkService) {
        self.authorizationService = authorizationService
    }
    
    func signInDidTapped(with userData: AuthorizationModel) {
        let email = userData.email
        let password = userData.password
        
        if !Validator.isValidEmail(for: email) {
            view?.showInvalidEmailError()
            return
        }
        
        if !Validator.isValidPassword(for: password) {
            view?.showInvalidPasswordError()
            return
        }
        
        view?.showLoader()
        authorizationService.authorizeUser(with: userData) { authorizationResult in
            self.view?.hideLoader()
            switch authorizationResult {
            case .success():
                self.view?.showHomeView()
            case .failure(let error):
                self.view?.showAuthorizationError(with: error)
            }
        }
    }
}
