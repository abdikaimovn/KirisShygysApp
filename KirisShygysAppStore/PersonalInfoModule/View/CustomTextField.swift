//
//  CustomTextField.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 09.03.2024.
//

import UIKit
import SnapKit

final class CustomTextField: UITextField {
    private let leftPaddingView = UIView()
    
    private let hidePasswordButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return button
    }()
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        configure(with: placeholder)
        setupSelf()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func configure(with placeholder: String) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.font: UIFont.font(style: .label, withSize: 14),
                         NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }
    
    @objc func hideTextField() {
        isSecureTextEntry = !isSecureTextEntry
        let imageName = isSecureTextEntry ? "eye.slash" : "eye"
        hidePasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func setupSelf() {
        isSecureTextEntry = true
        backgroundColor = .lightGrayColor
        
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        
        leftView = leftPaddingView
        leftViewMode = .always
        leftPaddingView.backgroundColor = .clear
        leftPaddingView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightView = rightPaddingView
        rightPaddingView.addSubview(hidePasswordButton)
        hidePasswordButton.center = rightPaddingView.center
        rightViewMode = .always
        hidePasswordButton.addTarget(self, action: #selector(hideTextField), for: .touchUpInside)
    }
}
