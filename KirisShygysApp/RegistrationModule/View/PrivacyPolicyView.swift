//
//  PrivacyPolicyView.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 17.04.2024.
//

import UIKit
import SnapKit

protocol PrivacyPolicyViewDelegate: AnyObject {
    func showPrivacyPolicyWebView()
    func disableSignUpButton()
    func enableSignUpButton()
}

final class PrivacyPolicyView: UIView {
    weak var delegate: PrivacyPolicyViewDelegate?
    
    //MARK: - UI Elements
    private let checkMarkButton: UIButton = {
        let button = ExtendedTapAreaButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .clear
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.cornerCurve = .continuous
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    private let privacyPolicyLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body, withSize: 14.0)
        label.textColor = .gray
        label.text = "privacyPolicyTextLabel".localized
        return label
    }()
    
    private let privacyPolicyLinkLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body, withSize: 14.0)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Functions
    @objc private func checkMarkTapped() {
        if checkMarkButton.tintColor == .clear {
            checkMarkButton.tintColor = .brownColor
            delegate?.enableSignUpButton()
        } else {
            checkMarkButton.tintColor = .clear
            delegate?.disableSignUpButton()
        }
    }
    
    private func setupCheckMarkButtonTarget() {
        checkMarkButton.addTarget(self, action: #selector(checkMarkTapped), for: .touchUpInside)
    }
    
    private func setupPrivacyLink() {
        let privacyLink = NSMutableAttributedString(attributedString:
            NSAttributedString(
                string: "privacyPolicyLinkLabel".localized,
                attributes: [
                    NSAttributedString.Key.font: UIFont.font(style: .body, withSize: 14.0),
                    NSAttributedString.Key.foregroundColor: UIColor.brownColor,
                    NSAttributedString.Key.underlineStyle: true]))
        
        privacyLink.append(NSAttributedString(string: "privacyPolicyAcceptLabel".localized,
                                              attributes: [
            NSAttributedString.Key.font: UIFont.font(style: .body, withSize: 14.0),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]))
        
        privacyPolicyLinkLabel.attributedText = privacyLink
        privacyPolicyLinkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkDidTapped)))
    }
    
    @objc private func linkDidTapped() {
        delegate?.showPrivacyPolicyWebView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubview(checkMarkButton)
        checkMarkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(15)
            make.size.equalTo(20)
        }
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = 1
        
        verticalStack.addArrangedSubview(privacyPolicyLabel)
        verticalStack.addArrangedSubview(privacyPolicyLinkLabel)
        
        addSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.leading.equalTo(checkMarkButton.snp.trailing).offset(10)
            make.centerY.equalTo(checkMarkButton.snp.centerY)
            make.trailing.equalToSuperview().inset(15)
        }
        
        setupPrivacyLink()
        setupCheckMarkButtonTarget()
    }
}
