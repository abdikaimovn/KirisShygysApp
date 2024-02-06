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
