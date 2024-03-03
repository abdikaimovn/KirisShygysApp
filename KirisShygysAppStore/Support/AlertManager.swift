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
    
    static func showAlertWithChoise(on vc: UIViewController, title: String, message: String?, completionHandler: @escaping (Bool) -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "yes_label".localized, style: .default) { _ in
            completionHandler(true)
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(yesAction)

        let noAction = UIAlertAction(title: "no_label".localized, style: .cancel) { _ in
            completionHandler(false)
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(noAction)

        vc.present(alertController, animated: true, completion: nil)
    }
}
