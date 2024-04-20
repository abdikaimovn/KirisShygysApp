//
//  PrivacyPolicyViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 18.04.2024.
//

import UIKit
import WebKit
import Network

final class PrivacyPolicyViewController: UIViewController {
    private let privacyPolicyWebView = WKWebView()
    private let presenter: PrivacyPresenter
    
    //MARK: - UI Elements
    private let networkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "network.slash")
        imageView.tintColor = .brownColor
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body, withSize: 18.0)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "network_error".localized
        return label
    }()
    
    private let loaderView = LoaderView()
    
    //MARK: - Lifecycle
    init(presenter: PrivacyPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.viewDidLoaded()
    }
    
    //MARK: - Functions
    private func setupView() {
        view.backgroundColor = .white
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.distribution = .equalSpacing
        verticalStack.spacing = 20
        
        verticalStack.addArrangedSubview(networkImageView)
        verticalStack.addArrangedSubview(messageLabel)
        
        networkImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
        
        view.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.center.equalToSuperview()
        }
        
        view.addSubview(privacyPolicyWebView)
        privacyPolicyWebView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        privacyPolicyWebView.isHidden = true
    }
}

extension PrivacyPolicyViewController: PrivacyViewProtocol {
    func showLoader() {
        loaderView.showLoader()
    }
    
    func hideLoader() {
        loaderView.hideLoader()
    }
    
    func showWebView(request: URLRequest) {
        privacyPolicyWebView.isHidden = false
        privacyPolicyWebView.load(request)
    }
}
