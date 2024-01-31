//
//  SceneDelegate.swift
//  KirisShygysAppAppStoreVersion
//
//  Created by Нурдаулет on 21.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupWindow(with: scene)
        getToNeededView()
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.overrideUserInterfaceStyle = .light
        self.window?.makeKeyAndVisible()
    }
    
    public func getToNeededView() {
        //        if AuthenticationService.checkAuthentication() == nil {
        let presenter = OnboardingPresenter()
        let view = OnboardingViewController(presenter: presenter)
        presenter.view = view
        let navController = UINavigationController(rootViewController: view)
        navController.modalPresentationStyle = .fullScreen
        goToController(with: navController)
        //        } else {
        //            let homeView = HomeViewController()
        //            let navController = UINavigationController(rootViewController: homeView)
        //            navController.modalPresentationStyle = .fullScreen
        //            self.goToController(with: navController)
        //        }
    }
    
    private func goToController(with viewController: UIViewController) {
        UIView.animate(withDuration: 0.1) {
            self.window?.layer.opacity = 0
        } completion: { [weak self] _ in
            let view = viewController
            view.modalPresentationStyle = .fullScreen
            self?.window?.rootViewController = view
            
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.window?.layer.opacity = 1
            }
        }
    }
}

