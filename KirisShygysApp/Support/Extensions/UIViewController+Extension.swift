//
//  UIViewController+Extension.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 01.02.2024.
//

import UIKit

extension UIViewController {
    var sceneDelegate: SceneDelegate? {
        view.window?.windowScene?.delegate as? SceneDelegate
    }
}

extension UIViewController {
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
