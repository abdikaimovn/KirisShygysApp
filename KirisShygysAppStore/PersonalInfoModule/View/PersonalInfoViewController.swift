//
//  PersonalInfoViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 07.03.2024.
//

import UIKit
import SnapKit

final class PersonalInfoViewController: UIViewController {
    //MARK: - UI Elements
    private let emailView = CustomView()
    private let nameView = CustomView()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0.7
        return view
    }()
    
    private let passwordView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 1, height: 4)
        view.layer.shadowRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    
    private let oldPasswordTextField = CustomTextField(placeholder: "oldPassword_placeholder".localized)
    private let newPasswordTextField = CustomTextField(placeholder: "newPassword_placeholder".localized)
    
    private let savePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("save_button_title".localized, for: .normal)
        button.backgroundColor = .brownColor
        button.titleLabel?.font = .font(style: .button)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    private let changePasswordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .font(style: .title, withSize: 12)
        label.text = "passwordChange_title".localized
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    //MARK: - Functions
    private func setupNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .brownColor
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    private func setupView() {
        view.backgroundColor = .lightGrayColor
        title = "personalInfo_label".localized.uppercased()
        
        view.addSubview(emailView)
        emailView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(nameView)
        nameView.snp.makeConstraints { make in
            make.top.equalTo(emailView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalTo(nameView.snp.bottom).offset(15)
            make.height.equalTo(0.5)
        }
        
        view.addSubview(passwordView)
        passwordView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(separatorView.snp.bottom).offset(15)
        }
        
        passwordView.addSubview(changePasswordLabel)
        changePasswordLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordView.addSubview(oldPasswordTextField)
        oldPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(changePasswordLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        passwordView.addSubview(newPasswordTextField)
        newPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(oldPasswordTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        passwordView.addSubview(savePasswordButton)
        savePasswordButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        setupSaveButtonTarget()
        setupToHideKeyboardOnTapOnView()
        
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
    }
    
    private func setupSaveButtonTarget() {
        savePasswordButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        
    }
}

extension PersonalInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Скрытие клавиатуры при нажатий кнопки Done(return)
        textField.resignFirstResponder()
        return true
    }
}
