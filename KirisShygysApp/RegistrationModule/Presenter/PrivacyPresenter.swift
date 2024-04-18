//
//  PrivacyPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 18.04.2024.
//

import Foundation

protocol PrivacyViewProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    func showWebView(request: URLRequest)
}

final class PrivacyPresenter {
    weak var view: PrivacyViewProtocol?
    func viewDidLoaded() {
        guard let url = URL(string: PrivacyPolicyURL.URLAddress) else {
            return
        }
        
        let requestToPrivacyWebPage = URLRequest(url: url)
        
        view?.showLoader()
        URLSession.shared.dataTask(with: requestToPrivacyWebPage) { [weak self] _, _, error in
            
            DispatchQueue.main.async {
                self?.view?.hideLoader()
            }
            
            if error == nil {
                DispatchQueue.main.async {
                    self?.view?.showWebView(request: requestToPrivacyWebPage)
                }
            }
        }.resume()
    }
}
