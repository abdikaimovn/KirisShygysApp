//
//  OnboardingPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 25.01.2024.
//

protocol OnboardingViewProtocol: AnyObject {
    func showAuthorizationPage()
}

final class OnboardingPresenter {
    weak var view: OnboardingViewProtocol?
    
    func signInDidTapped() {
        view?.showAuthorizationPage()
    }
}
