//
//  ViewController.swift
//  KirisShygysAppAppStoreVersion
//
//  Created by Нурдаулет on 21.01.2024.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    //Constant data
    private let onboardingData: [OnboardingModel] = [
        OnboardingModel(title: "onboarding_firstPage_title".localized,
                        description: "onboarding_firstPage_description".localized,
                        image: UIImage(named: "onbng1")!),
        OnboardingModel(title: "onboarding_secondPage_title".localized,
                        description:"onboarding_secondPage_description".localized,
                        image: UIImage(named: "onbng2")!)
    ]
    
    //UI Elements
    private lazy var sliderCollView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height * 0.6)
        var cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.dataSource = self
        cView.delegate = self
        cView.backgroundColor = .white
        cView.isPagingEnabled = true
        cView.showsHorizontalScrollIndicator = false
        cView.register(OnboardingCollectionCell.self, forCellWithReuseIdentifier: "OnboardingCollectionCell")
        return cView
    }()
    
    private let pageControl: UIPageControl = {
        var pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.shared.brownColor
        pageControl.pageIndicatorTintColor = .gray
        return pageControl
    }()
    
    private lazy var signUpButton: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var signInButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.setTitle("signIn_button_title".localized, for: .normal)
        button.backgroundColor = UIColor.shared.brownColor
        button.titleLabel?.font = UIFont.defaultButtonFont()
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    //MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
    }
    
    //TODO: - Создать модуль Авторизаций
    @objc func signIn() {
        
    }
    
    //TODO: - Создать модуль Регистраций
    @objc func signUp() {
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(sliderCollView)
        sliderCollView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        sliderCollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(sliderCollView.snp.bottom).offset(20)
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
            make.height.equalTo(1)
        }
        
        view.addSubview(signUpButton)
        signUpButton.setAttributedTitle(configureSignUpButtonTitle(), for: .normal)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    private func configureSignUpButtonTitle() -> NSAttributedString {
        let registrationTitle = NSMutableAttributedString(string: "absentAccount_title".localized,
                                                          attributes: [
                                                            NSAttributedString.Key.font: UIFont.defaultFont(),
                                                            NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        registrationTitle.append(NSAttributedString(string: "signUp_button_title".localized, 
                                                    attributes: [
                                                        NSAttributedString.Key.font: UIFont.defaultBoldFont(),
                                                        NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                                                        NSAttributedString.Key.underlineStyle: true]))
        return registrationTitle
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionCell", for: indexPath) as! OnboardingCollectionCell
        cell.configure(onboardingModel: onboardingData[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        pageControl.currentPage = Int(scrollView.contentOffset.x / width)
    }
}
