//
//  ViewController.swift
//  KirisShygysAppAppStoreVersion
//
//  Created by Нурдаулет on 21.01.2024.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    private let presenter: OnboardingPresenter
    
    //MARK: - Constant data
    private let onboardingData: [OnboardingModel] = [
        OnboardingModel(title: "onboarding_firstPage_title".localized,
                        description: "onboarding_firstPage_description".localized,
                        image: UIImage(named: "onbng1")),
        OnboardingModel(title: "onboarding_secondPage_title".localized,
                        description:"onboarding_secondPage_description".localized,
                        image: UIImage(named: "onbng2"))
    ]
    
    //MARK: - UI Elements
    private let sliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        var pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .brownColor
        pageControl.pageIndicatorTintColor = .gray
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private let signUpButton = UIButton()
    
    private let signInButton = UIButton()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    //MARK: - Lifecycle
    init(presenter: OnboardingPresenter) {
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

    @objc func signIn() {
        presenter.signInDidTapped()
    }

    @objc func signUp() {
        presenter.signUpDidTapped()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(sliderCollectionView)
        
        sliderCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(sliderCollectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }
        
        view.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(0.5)
        }
        
        view.addSubview(signUpButton)
        signUpButton.setAttributedTitle(setupSignUpButton(), for: .normal)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        setupSignInButton()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        sliderCollectionView.isPagingEnabled = true
        sliderCollectionView.showsHorizontalScrollIndicator = false
        sliderCollectionView.register(OnboardingCollectionCell.self, forCellWithReuseIdentifier: OnboardingCollectionCell.typeName)
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
    }
    
    private func setupSignInButton() {
        signInButton.layer.cornerRadius = 15
        signInButton.clipsToBounds = true
        signInButton.setTitle("signIn_button_title".localized, for: .normal)
        signInButton.backgroundColor = .brownColor
        signInButton.titleLabel?.font = UIFont.font(style: .button)
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
    
    private func setupSignUpButton() -> NSAttributedString {
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        let registrationTitle = NSMutableAttributedString(string: "absentAccount_title".localized,
                                                          attributes: [
                                                            NSAttributedString.Key.font: UIFont.font(style: .body),
                                                            NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        registrationTitle.append(NSAttributedString(string: "signUp_button_title".localized,
                                                    attributes: [
                                                        NSAttributedString.Key.font: UIFont.font(style: .body),
                                                        NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                                                        NSAttributedString.Key.underlineStyle: true]))
        return registrationTitle
    }
    
    private func createAuthorizationModule() -> UIViewController {
        let networkService = AuthenticationService()
        let presenter = AuthorizationPresenter(authorizationService: networkService)
        let view = AuthorizationViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
    private func createRegistrationModule() -> UIViewController {
        let networkService = AuthenticationService()
        let presenter = RegistrationPresenter(networkService: networkService)
        let view = RegistrationViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionCell.typeName, for: indexPath) as? OnboardingCollectionCell {
            cell.configure(onboardingModel: onboardingData[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell(frame: .zero)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        pageControl.currentPage = Int(scrollView.contentOffset.x / width)
    }
}

extension OnboardingViewController: OnboardingViewProtocol {
    func showRegistrationPage() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .brownColor
        navigationItem.backBarButtonItem = backBarButtonItem
        
        let registrationView = createRegistrationModule()
        
        self.navigationController?.pushViewController(registrationView, animated: true)
    }
    
    func showAuthorizationPage() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .brownColor
        navigationItem.backBarButtonItem = backBarButtonItem
        
        let authorizationView = createAuthorizationModule()
        
        self.navigationController?.pushViewController(authorizationView, animated: true)
    }
}
