//
//  SendEmailView.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 11.03.2024.
//

import UIKit
import Lottie
import SnapKit

protocol SendEmailAnimationDelegate: AnyObject {
    func okDidTapped()
}

final class SentEmailAnimatedView: UIView {
    weak var parent: SendEmailAnimationDelegate?
    private let animationView = LottieAnimationView(name: "successAnimation.json")
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body, withSize: 13)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        return view
    }()
    
    private let okButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .font(style: .body, withSize: 18)
        button.setTitle("Ок", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    @objc private func okDidTapped() {
        parent?.okDidTapped()
    }
    
    func configure(with message: String) {
        messageLabel.text = message
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 1, height: 4)
        layer.shadowRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        
        addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview()
            make.size.equalTo(120)
        }

        setupAnimation()
        
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        addSubview(okButton)
        okButton.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
        okButton.addTarget(self, action: #selector(okDidTapped), for: .touchUpInside)
    }
    
    private func setupAnimation() {
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
    }
    
    func playAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animationView.play()
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
    
}
