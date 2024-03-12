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
        showLaunchScreenAnimation()
     }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.overrideUserInterfaceStyle = .light
        self.window?.makeKeyAndVisible()
    }
    
    func updateRootView() {
        showInitialModule()
    }
    
    private func showLaunchScreenAnimation() {
        self.window?.rootViewController = LaunchScreenViewController()
    }
    
    func showInitialModule() {
        if AuthenticationService.user != nil {
            goToControllerWithAnimation(UINavigationController(rootViewController: TabBarContoller()))
        } else {
            let presenter = OnboardingPresenter()
            let view = OnboardingViewController(presenter: presenter)
            presenter.view = view
            let navController = UINavigationController(rootViewController: view)
            goToControllerWithAnimation(navController)
        }
    }
    
    private func goToControllerWithAnimation(_ viewController: UIViewController) {
        UIView.animate(withDuration: 0.2) {
            self.window?.layer.opacity = 0
        } completion: { _ in
            let view = viewController
            view.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = view
            
            UIView.animate(withDuration: 0.3) {
                self.window?.layer.opacity = 1
            }
        }
    }
}

