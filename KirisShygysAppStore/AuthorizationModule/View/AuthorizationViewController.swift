//
//  AuthorizationViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 24.01.2024.
//

import UIKit
import SnapKit

final class AuthorizationViewController: UIViewController {
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
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1.0
        textField.layer.masksToBounds = true
        textField.placeholder = "email_textField_placeholder".localized
        textField.textColor = .black
        textField.font = UIFont.font(style: .body)
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1.0
        textField.isSecureTextEntry = true
        textField.layer.masksToBounds = true
        textField.placeholder = "password_textField_placeholder".localized
        textField.textColor = .black
        return textField
    }()
    
    private let hidePasswordFieldButton = UIButton()
    
    private let signInButton = UIButton()
    
    //MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.becomeFirstResponder()
    }
    
    //TODO: Реализовать вход в систему
    @objc func signInPressed() {

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
        signInButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }

    @objc func hideTextField(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        hidePasswordFieldButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func setupView() {
        view.backgroundColor = .white
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
        
        //Имитация отступа у textFields
        let leftPaddingViewName = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        emailTextField.leftView = leftPaddingViewName
        emailTextField.leftViewMode = .always
        
        let leftPaddingViewPassword = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        passwordTextField.leftView = leftPaddingViewPassword
        passwordTextField.leftViewMode = .always
        
        //Кнопка скрытия и показа текста в passwordTextField
        let rightPaddingButton = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightPaddingButton.addSubview(hidePasswordFieldButton)
        
        hidePasswordFieldButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        
        passwordTextField.rightView = rightPaddingButton
        passwordTextField.rightViewMode = .always
        
        setupSignInButton()
        setupHidePasswordButton()
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Скрытие клавиатуры при нажатий кнопки Done(return)
        textField.resignFirstResponder()
        return true
    }
}
