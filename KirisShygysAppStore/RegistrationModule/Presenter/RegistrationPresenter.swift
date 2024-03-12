//
//  RegistrationPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

protocol RegistrationViewProtocol: AnyObject {
    func showRegistrationError(with model: NetworkErrorModel)
    func showInvalidEmailError()
    func showInvalidUsernameError()
    func showInvalidPasswordError()
    func showLoader()
    func hideLoader()
    func showVerifyEmailAlert()
}

final class RegistrationPresenter {
    weak var view: RegistrationViewProtocol?
    private let networkService: RegistrationNetworkService
    
    init(networkService: RegistrationNetworkService) {
        self.networkService = networkService
    }
    
    func signUpDidTapped(with userData: RegistrationModel) {
        guard let username = userData.name, Validator.isValidUsername(for: username) else {
            view?.showInvalidUsernameError()
            return
        }
        
        guard let email = userData.email, Validator.isValidEmail(for: email) else {
            view?.showInvalidEmailError()
            return
        }
        
        guard let password = userData.password, Validator.isValidPassword(for: password) else {
            view?.showInvalidPasswordError()
            return
        }
        
        view?.showLoader()
        networkService.registerUser(with: userData) { [weak self] registrationResult in
            self?.view?.hideLoader()
            switch registrationResult {
            case .success():
                AuthenticationService.sendEmailVerificationLink()
                self?.networkService.logOut()
                self?.view?.showVerifyEmailAlert()
            case .failure(let error):
                self?.view?.showRegistrationError(with: error)
            }
        }
    }
}
