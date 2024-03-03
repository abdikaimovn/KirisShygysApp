//
//  RegistrationViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 25.01.2024.
//

import UIKit
import SnapKit

final class RegistrationViewController: UIViewController {
    private let presenter: RegistrationPresenter
    
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
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont.font(style: .body)
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    private let loaderView = LoaderView(frame: .zero)
    
    private let nameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    
    private let hidePasswordFieldButton = UIButton()
    
    private let signUpButton = UIButton()
    
    //MARK: - Lifecycle
    init(presenter: RegistrationPresenter) {
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
    
    private func setupTextFields() {
        [nameTextField, emailTextField, passwordTextField].forEach { textField in
            textField.borderStyle = .line
            textField.layer.cornerRadius = 10
            textField.layer.borderWidth = 1.0
            textField.layer.masksToBounds = true
            textField.textColor = .black
            textField.font = UIFont.font(style: .body)
        }
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        passwordTextField.isSecureTextEntry = true
        
        nameTextField.placeholder = "name_textField_placeholder".localized
        emailTextField.placeholder = "email_textField_placeholder".localized
        passwordTextField.placeholder = "password_textField_placeholder".localized
        
        addingPaddingsInTextFields()
    }
    
    private func addingPaddingsInTextFields() {
        //Имитация отступа у textFields
        let leftPaddingViewName = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        nameTextField.leftView = leftPaddingViewName
        nameTextField.leftViewMode = .always
        
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

    @objc func signUpPressed() {
        errorLabel.isHidden = true
        presenter.signUpDidTapped(with: RegistrationModel(
            name: nameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text)
        )
    }
    
    private func setupHidePasswordButton() {
        hidePasswordFieldButton.tintColor = .black
        hidePasswordFieldButton.setImage(UIImage(systemName:"eye.slash"), for: .normal)
        hidePasswordFieldButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        hidePasswordFieldButton.addTarget(self, action: #selector(hideTextField(_:)), for: .touchUpInside)
    }
    
    private func setupSignUpButton() {
        signUpButton.backgroundColor = UIColor.brownColor
        signUpButton.setTitle("signUp_button_title".localized, for: .normal)
        signUpButton.layer.cornerRadius = 12
        signUpButton.titleLabel?.font = UIFont.font(style: .button)
        signUpButton.clipsToBounds = true
        signUpButton.tintColor = .black
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        signUpButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }

    @objc func hideTextField(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        hidePasswordFieldButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        setupSignUpButton()
        setupHidePasswordButton()
        setupTextFields()
        setupToHideKeyboardOnTapOnView()
        
        view.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.size.equalTo(view.bounds.width * 0.2)
        }
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(imageLogo.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(55)
        }
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(signUpButton.snp.bottom).offset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(70)
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Скрытие клавиатуры при нажатий кнопки Done(return)
        textField.resignFirstResponder()
        return true
    }
}

extension RegistrationViewController: RegistrationViewProtocol {
    func showInvalidEmailError() {
        errorLabel.text = "invalidEmail_error".localized
        errorLabel.isHidden = false
    }
    
    func showInvalidUsernameError() {
        errorLabel.text = "invalidUsername_error".localized
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
    
    func showRegistrationError(with model: NetworkErrorModel) {
        AlertManager.showAlert(on: self, title: model.title, message: model.description)
    }
    
    func showHomeView() {
        sceneDelegate?.showInitialModule()
    }
}
