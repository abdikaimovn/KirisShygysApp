//
//  ResetPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 10.03.2024.
//

import AudioToolbox

protocol ResetViewProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    func showFailure(failure: NetworkErrorModel)
    func showInvalidEmailError()
    func showEmailSentView()
}

final class ResetPresenter {
    weak var view: ResetViewProtocol?
    private let authService: AuthorizationNetworkService
    
    init(authService: AuthorizationNetworkService) {
        self.authService = authService
    }
    
    func resetButtonTapped(_ email: String?) {
        guard let email, Validator.isValidEmail(for: email) else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            view?.showInvalidEmailError()
            return
        }
        
        view?.showLoader()
        authService.resetPassword(with: email.lowercased()) { [weak self] result in
            self?.view?.hideLoader()
            switch result {
            case .success(_):
                self?.view?.showEmailSentView()
            case .failure(let failure):
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self?.view?.showFailure(failure: failure)
            }
        }
    }
}
