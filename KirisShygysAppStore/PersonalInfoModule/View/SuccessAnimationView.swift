//
//  AnimatingSuccessView.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 10.03.2024.
//

import UIKit
import Lottie
import SnapKit

protocol SuccessAnimationDelegate: AnyObject {
    func restartDidTapped()
}

final class SuccessAnimationView: UIView {
    weak var parent: SuccessAnimationDelegate?
    private let animationView = LottieAnimationView(name: "Animation 1710059075673.json")
    
    private let restartButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .font(style: .button)
        button.setTitle("restart_button_title".localized, for: .normal)
        button.backgroundColor = .incomeColor
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
    
    @objc private func restartDidTapped() {
        parent?.restartDidTapped()
    }
    
    private func setupView() {
        backgroundColor = .white
    
        animationView.layer.cornerRadius = 15
        animationView.layer.cornerCurve = .continuous
        
        addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.size.equalTo(150)
        }
        
        setupAnimation()
        
        addSubview(restartButton)
        restartButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        restartButton.addTarget(self, action: #selector(restartDidTapped), for: .touchUpInside)
    }
    
    private func setupAnimation() {
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
    }
    
    func playAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animationView.play()
        }
    }
}
