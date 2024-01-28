//
//  AlertManager.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

import UIKit

final class AlertManager {
    static func showAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "alert_dismissButton_title".localized, style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}
