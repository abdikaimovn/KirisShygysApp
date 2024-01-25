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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        //TODO: Исправить после реализаций NETWORK Layer, пока можно
        let onboardingPresenter = OnboardingPresenter()
        let onboardingView = OnboardingViewController(presenter: onboardingPresenter)
        onboardingPresenter.view = onboardingView
        
        window?.rootViewController = UINavigationController(rootViewController: onboardingView)
        window?.makeKeyAndVisible()
    }
}

