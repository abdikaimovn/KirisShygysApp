//
//  PersonalInfoViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 07.03.2024.
//

import UIKit
import SnapKit

final class PersonalInfoViewController: UIViewController {
    private let presenter: PersonalInfoPresenter
    
    //MARK: - UI Elements
    private let emailView = CustomView()
    private let nameView = CustomView()
    private var animationView: AnimatingSuccessView?
    
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
        label.font = .font(style: .title, withSize: 16)
        label.text = "passwordChange_title".localized
        label.textAlignment = .center
        return label
    }()
    
    private let loaderView = LoaderView(with: .large)
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body, withSize: 14)
        label.textColor = .red
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    //MARK: - Lifecycle
    init(presenter: PersonalInfoPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
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
        presenter.viewDidLoad()
    }
    
    //MARK: - Functions
    private func setupNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .brownColor
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    private func setupTextFieldsDelegates() {
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
    }
    
    private func setupAnimationView() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        animationView = AnimatingSuccessView(frame: view.frame)
        
        view.addSubview(animationView!)
        animationView!.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
    }
    
    private func setupView() {
        view.backgroundColor = .lightGrayColor
        title = "personalInfo_label".localized
        
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
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalTo(passwordView.snp.bottom).offset(20)
        }
        
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupSaveButtonTarget()
        setupToHideKeyboardOnTapOnView()
        setupTextFieldsDelegates()
    }
    
    private func setupSaveButtonTarget() {
        savePasswordButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        presenter.saveDidTapped(PasswordModel(oldPassword: oldPasswordTextField.text,
                                              newPassword: newPasswordTextField.text))
    }
}

extension PersonalInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Скрытие клавиатуры при нажатий кнопки Done(return)
        textField.resignFirstResponder()
        return true
    }
}

extension PersonalInfoViewController: PersonalInfoViewProtocol {
    func hideInvalidPasswordError() {
        errorLabel.isHidden = true
    }
    
    func showSuccess() {
        setupAnimationView()
        
        animationView?.playAnimation()
    }
    
    func showInvalidPasswordError() {
        errorLabel.text = "invalidPassword_error".localized
        errorLabel.isHidden = false
    }
    
    func configureUsername(_ username: String) {
        nameView.configure(imageName: "person", title: username)
    }
    
    func configureEmailLabel(_ email: String) {
        emailView.configure(imageName: "envelope", title: email)
    }
    
    func showFailure(_ failure: NetworkErrorModel) {
        AlertManager.showAlert(on: self, title: failure.title, message: failure.description)
    }
    
    func showLoader() {
        loaderView.showLoader()
    }
    
    func hideLoader() {
        loaderView.hideLoader()
    }
}
