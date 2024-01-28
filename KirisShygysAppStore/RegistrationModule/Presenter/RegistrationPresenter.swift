//
//  RegistrationPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

protocol RegistrationViewProtocol: AnyObject {
    func showRegistrationError(with model: NetworkErrorModel)
    func showHomeView()
    func showInvalidEmailError()
    func showInvalidUsernameError()
    func showInvalidPasswordError()
    func showLoader()
    func hideLoader()
}

final class RegistrationPresenter {
    weak var view: RegistrationViewProtocol?
    private let networkService: RegistrationNetworkService
    
    init(networkService: RegistrationNetworkService) {
        self.networkService = networkService
    }
    
    func signUpDidTapped(with userData: RegistrationModel) {
        if !Validator.isValidUsername(for: userData.name) {
            view?.showInvalidUsernameError()
            return
        }
        
        if !Validator.isValidEmail(for: userData.email) {
            view?.showInvalidEmailError()
            return
        }
        
        if !Validator.isValidPassword(for: userData.password) {
            view?.showInvalidPasswordError()
            return
        }
        
        view?.showLoader()
        networkService.registerUser(with: userData) { registrationResult in
            self.view?.hideLoader()
            switch registrationResult {
            case .success():
                self.view?.showHomeView()
            case .failure(let error):
                self.view?.showRegistrationError(with: error)
            }
        }
    }
}
