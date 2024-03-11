//
//  AuthorizationViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 24.01.2024.
//

import UIKit
import SnapKit

final class AuthorizationViewController: UIViewController {
    private let presenter: AuthorizationPresenter
    
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
    private let passwordTextField = UITextField()
    
    private let hidePasswordFieldButton = UIButton()
    
    private let signInButton = UIButton()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont.font(style: .body)
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    private let loaderView = LoaderView(frame: .zero)
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var forgetPasswordLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body)
        label.textColor = .brownColor
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgetPasswordDidTapped)))
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.attributedText = NSAttributedString(string: "forgetPassword_label".localized, attributes: [NSAttributedString.Key.underlineStyle: true])
        return label
    }()
    
    //MARK: - Lifecycle
    init(presenter: AuthorizationPresenter) {
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
    
    //MARK: - Objc Functions
    @objc private func signInPressed() {
        errorLabel.isHidden = true
        presenter.signInDidTapped(with: AuthorizationModel(
            email: emailTextField.text,
            password: passwordTextField.text)
        )
    }
    
    @objc private func hideTextField(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        hidePasswordFieldButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func forgetPasswordDidTapped() {
        presenter.forgetPasswordDidTapped()
    }
    
    //MARK: - Functions
    private func setupTextFields() {
        [emailTextField, passwordTextField].forEach { textField in
            textField.borderStyle = .line
            textField.layer.cornerRadius = 10
            textField.layer.borderWidth = 1.0
            textField.layer.masksToBounds = true
            textField.textColor = .black
            textField.font = UIFont.font(style: .body)
        }
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.placeholder = "email_textField_placeholder".localized
        passwordTextField.placeholder = "password_textField_placeholder".localized
        
        passwordTextField.isSecureTextEntry = true
        
        addingPaddingsInTextFields()
    }
    
    private func addingPaddingsInTextFields() {
        //Имитация отступа у textFields
        let leftPaddingViewEmail = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        emailTextField.leftView = leftPaddingViewEmail
        emailTextField.leftViewMode = .always
        
        let leftPaddingViewPassword = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        passwordTextField.leftView = leftPaddingViewPassword
        passwordTextField.leftViewMode = .always
        
        //Кнопка скрытия и показа текста в passwordTextField
        let rightViewButton = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightViewButton.addSubview(hidePasswordFieldButton)
        
        passwordTextField.rightView = rightViewButton
        passwordTextField.rightViewMode = .always
    }
    
    private func setupHidePasswordButton() {
        hidePasswordFieldButton.tintColor = .black
        hidePasswordFieldButton.setImage(UIImage(systemName:"eye.slash"), for: .normal)
        hidePasswordFieldButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        hidePasswordFieldButton.addTarget(self, action: #selector(hideTextField(_:)), for: .touchUpInside)
    }
    
    private func setupSignInButton() {
        signInButton.backgroundColor = UIColor.brownColor
        signInButton.setTitle("signIn_button_title".localized, for: .normal)
        signInButton.layer.cornerRadius = 12
        signInButton.titleLabel?.font = UIFont.font(style: .button)
        signInButton.clipsToBounds = true
        signInButton.tintColor = .black
        signInButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside) 
    }
    
    private func createResetPasswordModule() -> UIViewController {
        let service = AuthenticationService()
        let presenter = ResetPresenter(authService: service)
        let view = ResetViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        setupSignInButton()
        setupHidePasswordButton()
        setupTextFields()
        setupToHideKeyboardOnTapOnView()
        
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
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(55)
        }
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(signInButton.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        view.addSubview(forgetPasswordLabel)
        forgetPasswordLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(separatorView.snp.bottom).offset(15)
        }
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(forgetPasswordLabel.snp.bottom).offset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(70)
        }
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Скрытие клавиатуры при нажатий кнопки Done(return)
        textField.resignFirstResponder()
        return true
    }
}

extension AuthorizationViewController: AuthorizationViewProtocol {
    func showInvalidEmailError() {
        errorLabel.text = "invalidEmail_error".localized
        errorLabel.isHidden = false
    }
    
    func showInvalidPasswordError() {
        errorLabel.text = "invalidPassword_error".localized
        errorLabel.isHidden = false
    }
    
    func showLoader() {
        loaderView.showLoader()
    }
    
    func hideLoader() {
        loaderView.hideLoader()
    }
    
    func showInitialModule() {
        sceneDelegate?.showInitialModule()
    }
    
    func showAuthorizationError(with error: NetworkErrorModel) {
        AlertManager.showAlert(on: self, title: error.title, message: error.description)
    }
    
    func showResetPasswordModule() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .brownColor
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(createResetPasswordModule(), animated: true)
    }
}
