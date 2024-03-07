//
//  AuthorizationPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

protocol AuthorizationViewProtocol: AnyObject{
    func showInvalidEmailError()
    func showInvalidPasswordError()
    func showInitialModule()
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
        guard let email = userData.email, Validator.isValidEmail(for: email) else {
            view?.showInvalidEmailError()
            return
        }
        
        guard let password = userData.password, Validator.isValidPassword(for: password) else {
            view?.showInvalidPasswordError()
            return
        }
        
        view?.showLoader()
        authorizationService.authorizeUser(with: userData) { [weak self] authorizationResult in
            self?.view?.hideLoader()
            switch authorizationResult {
            case .success():
                self?.view?.showInitialModule()
            case .failure(let error):
                self?.view?.showAuthorizationError(with: error)
            }
        }
    }
}
