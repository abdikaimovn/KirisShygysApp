//
//  ResetViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 10.03.2024.
//

import UIKit
import SnapKit

final class ResetViewController: UIViewController {
    private let presenter: ResetPresenter
    private var sendEmailView: SentEmailAnimatedView?
    
    //MARK: - UI Elements
    private let imageLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailTextField = UITextField()
    
    private let resetButton = UIButton()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "invalidEmail_error".localized
        label.font = UIFont.font(style: .body)
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    private let loaderView = LoaderView(with: .large)
    
    //MARK: - Lifecycle
    init(presenter: ResetPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    //MARK: - Functions
    private func setupForgetPasswordButton() {
        resetButton.backgroundColor = UIColor.brownColor
        resetButton.setTitle("resetPassword_title".localized, for: .normal)
        resetButton.layer.cornerRadius = 12
        resetButton.titleLabel?.font = UIFont.font(style: .button)
        resetButton.clipsToBounds = true
        resetButton.tintColor = .black
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
    }
    
    @objc private func resetButtonPressed() {
        presenter.resetButtonTapped(emailTextField.text)
    }
    
    private func setupSendEmailView() {
        sendEmailView = SentEmailAnimatedView(frame: view.frame)
        
        guard let sendEmailView else {
            return
        }
        
        view.addSubview(sendEmailView)
        
        sendEmailView.parent = self
        
        sendEmailView.configure(with: "resetPassword_message".localized)
        sendEmailView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
        }
        
        sendEmailView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.sendEmailView?.alpha = 1
        })
    }
    
    private func setupTextField() {
        emailTextField.placeholder = "email_textField_placeholder".localized
        emailTextField.delegate = self
        emailTextField.borderStyle = .line
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.masksToBounds = true
        emailTextField.textColor = .black
        emailTextField.font = UIFont.font(style: .body)
        
        //Имитация отступа у textFields
        let leftPaddingViewEmail = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        emailTextField.leftView = leftPaddingViewEmail
        emailTextField.leftViewMode = .always
        
        setupToHideKeyboardOnTapOnView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = ""
        
        setupTextField()
        setupForgetPasswordButton()
        
        view.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.size.equalTo(view.bounds.width * 0.2)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(imageLogo.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
        
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(20)
            make.top.equalTo(resetButton.snp.bottom).offset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
        
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(70)
        }
    }
}

extension ResetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Скрытие клавиатуры при нажатий кнопки Done(return)
        textField.resignFirstResponder()
        return true
    }
}

extension ResetViewController: ResetViewProtocol {
    func showLoader() {
        loaderView.showLoader()
    }
    
    func hideLoader() {
        loaderView.hideLoader()
    }
    
    func showFailure(failure: NetworkErrorModel) {
        AlertManager.showAlert(on: self, title: failure.title, message: failure.description)
    }
    
    func showInvalidEmailError() {
        errorLabel.isHidden = false
    }
    
    func showEmailSentView() {
        errorLabel.isHidden = true
        setupSendEmailView()
        sendEmailView?.playAnimation()
    }
}

extension ResetViewController: SendEmailAnimationDelegate {
    func okDidTapped() {
        sendEmailView?.removeFromSuperview()
        navigationController?.popViewController(animated: true)
    }
}
