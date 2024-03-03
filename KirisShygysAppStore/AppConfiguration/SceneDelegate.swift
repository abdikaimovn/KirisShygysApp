//
//  SceneDelegate.swift
//  KirisShygysAppAppStoreVersion
//
//  Created by Нурдаулет on 21.01.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupWindow(with: scene)
        configureAppLanguage()
        showInitialModule()
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.overrideUserInterfaceStyle = .light
        self.window?.makeKeyAndVisible()
    }
    
    private func configureAppLanguage() {
        LanguageHandler.configureAppLanguage()
    }
    
    func restartApp() {
        configureAppLanguage()
        showInitialModule()
    }
    
    func showInitialModule() {
        if AuthenticationService.user == nil {
            let presenter = OnboardingPresenter()
            let view = OnboardingViewController(presenter: presenter)
            presenter.view = view
            let navController = UINavigationController(rootViewController: view)
            goToController(navController)
        } else {
            goToController(UINavigationController(rootViewController: TabBarContoller()))
        }
    }
    
    private func goToController(_ viewController: UIViewController) {
        UIView.animate(withDuration: 0.1) {
            self.window?.layer.opacity = 0
        } completion: { _ in
            let view = viewController
            view.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = view
            
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.window?.layer.opacity = 1
            }
        }
    }
}

