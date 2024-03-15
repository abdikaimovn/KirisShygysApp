//
//  PersonalInfoPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 09.03.2024.
//
import Foundation
import AudioToolbox

protocol PersonalInfoViewProtocol: AnyObject {
    func configureUsername(_ username: String)
    func configureEmailLabel(_ email: String)
    func showFailure(_ failure: NetworkErrorModel)
    func showLoader()
    func hideLoader()
    func showInvalidPasswordError()
    func hideInvalidPasswordError()
    func showSuccess()
}

final class PersonalInfoPresenter {
    weak var view: PersonalInfoViewProtocol?
    private let userDataService: PersonalInfoService
    private let authenticationService: ServicesAuthenticationProtocol
    
    init(userDataService: PersonalInfoService, authenticationService: ServicesAuthenticationProtocol) {
        self.userDataService = userDataService
        self.authenticationService = authenticationService
    }
    
    func viewDidLoad() {
        retrieveUsername()
        retrieveEmail()
    }
    
    private func retrieveUsername() {
        view?.showLoader()
        userDataService.fetchUsername { [weak self] result in
            self?.view?.hideLoader()
            switch result {
            case .success(let username):
                self?.view?.configureUsername(username)
            case .failure(let failure):
                self?.view?.showFailure(failure)
                self?.view?.configureUsername("")
            }
        }
    }
    
    private func retrieveEmail() {
        userDataService.fetchUserEmail { [weak self] result in
            switch result {
            case .success(let email):
                self?.view?.configureEmailLabel(email)
            case .failure(let failure):
                self?.view?.showFailure(failure)
                self?.view?.configureEmailLabel("")
            }
        }
    }
    
    func saveDidTapped(_ password: PasswordModel) {
        guard let oldPassword = password.oldPassword, Validator.isValidPassword(for: oldPassword) else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            view?.showInvalidPasswordError()
            return
        }
        
        guard let newPassword = password.newPassword, Validator.isValidPassword(for: newPassword) else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            view?.showInvalidPasswordError()
            return
        }
        
        let credential = PasswordModel(oldPassword: oldPassword, newPassword: newPassword)
    
        view?.showLoader()
        authenticationService.changeUserPassword(with: credential) { [weak self] result in
            self?.view?.hideLoader()
            switch result {
            case .success(_):
                self?.view?.hideInvalidPasswordError()
                self?.authenticationService.passwordDidChange()
                self?.view?.showSuccess()
            case .failure(let failure):
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self?.view?.showFailure(failure)
            }
        }
    }
}
