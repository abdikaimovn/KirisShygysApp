//
//  AuthorizationPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

import AudioToolbox

protocol AuthorizationViewProtocol: AnyObject{
    func showInvalidEmailError()
    func showInvalidPasswordError()
    func showInitialModule()
    func showAuthorizationError(with error: NetworkErrorModel)
    func showLoader()
    func hideLoader()
    func showResetPasswordModule()
}

final class AuthorizationPresenter {
    weak var view: AuthorizationViewProtocol?
    private let authorizationService: AuthorizationNetworkService
    
    init(authorizationService: AuthorizationNetworkService) {
        self.authorizationService = authorizationService
    }
    
    func forgetPasswordDidTapped() {
        view?.showResetPasswordModule()
    }
    
    func signInDidTapped(with userData: AuthorizationModel) {
        guard let email = userData.email, Validator.isValidEmail(for: email) else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            view?.showInvalidEmailError()
            return
        }
        
        guard let password = userData.password, Validator.isValidPassword(for: password) else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
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
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self?.view?.showAuthorizationError(with: error)
            }
        }
    }
}
