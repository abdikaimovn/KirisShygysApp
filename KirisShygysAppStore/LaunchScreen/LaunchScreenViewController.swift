//
//  LaunchScreenViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 12.03.2024.
//

import UIKit
import SnapKit

final class LaunchScreenViewController: UIViewController {
    private let animationText = "kiris\nshyǵys"
    
    private let firstBlurCircle = UIImageView()
    private let secondBlurCircle = UIImageView()
    private let thirdBlurCircle = UIImageView()
    
    private var animationIndex: String.Index?
    private var animationTimer: Timer?

    private let canvasView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private let animationLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .button, withSize: 60)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body, withSize: 18)
        label.textAlignment = .center
        label.text = "Bizben birge qarjylyq saýatty bolyńyz"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        playAnimation()
    }
    
    private func setupView() {
        view.backgroundColor = .lightBrownColor
        
        view.addSubview(canvasView)
        canvasView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.size.equalTo(view.frame.width)
            make.centerY.equalToSuperview()
        }
        
        canvasView.addSubview(firstBlurCircle)
        firstBlurCircle.snp.makeConstraints { make in
            make.size.equalTo(180)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(-40)
        }
        
        canvasView.addSubview(secondBlurCircle)
        secondBlurCircle.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(100)
            make.top.equalTo(firstBlurCircle.snp.centerY).offset(20)
            make.size.equalTo(80)
        }
        
        canvasView.addSubview(animationLabel)
        animationLabel.snp.makeConstraints { make in
            make.top.equalTo(firstBlurCircle.snp.centerY).offset(10)
            make.leading.equalTo(firstBlurCircle.snp.trailing).inset(50)
        }
        
        canvasView.addSubview(thirdBlurCircle)
        thirdBlurCircle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(50)
            make.top.equalTo(animationLabel.snp.bottom).inset(20)
            make.size.equalTo(150)
        }
        
        setupBlurCircles()
        
        view.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(15)
        }
    }

    private func playAnimation() {
        animationTimer?.invalidate()
        animationIndex = animationText.startIndex
        animationLabel.text = ""
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.09, repeats: true) { timer in
            guard let currentIndex = self.animationIndex else {
                timer.invalidate()
                return
            }
            
            if currentIndex < self.animationText.endIndex {
                let nextIndex = self.animationText.index(after: currentIndex)
                let nextLetter = self.animationText[currentIndex..<nextIndex]
                self.animationLabel.text? += String(nextLetter)
                self.animationIndex = nextIndex
            } else {
                timer.invalidate()
                self.animateBlurCircles()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.sceneDelegate?.showInitialModule()
                }
            }
        }
    }
    
    private func animateBlurCircles() {
        UIView.animate(withDuration: 0.3) {
            self.firstBlurCircle.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.secondBlurCircle.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.thirdBlurCircle.alpha = 1
                }
            }
        }
    }

    private func setupBlurCircles() {
        [firstBlurCircle, secondBlurCircle, thirdBlurCircle].forEach { imageView in
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "blurCircle")
            imageView.backgroundColor = .clear
            imageView.alpha = 0
        }
    }
}
