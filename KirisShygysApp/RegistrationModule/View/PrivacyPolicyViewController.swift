//
//  PrivacyPolicyViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 18.04.2024.
//

import UIKit
import WebKit

final class PrivacyPolicyViewController: UIViewController {
    private let privacyPolicyWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePrivacyPolicyWebView()
        
        view = privacyPolicyWebView
    }
    
    private func configurePrivacyPolicyWebView() {
        guard let url = URL(string: PrivacyPolicyURL.URLAddress) else { return }
        
        let requestToPrivacyWebPage = URLRequest(url: url)

        privacyPolicyWebView.load(requestToPrivacyWebPage)
    }
}
