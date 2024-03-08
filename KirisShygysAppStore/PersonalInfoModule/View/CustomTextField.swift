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
    
    init(placeholder: String) {
        super.init(frame: .zero)
        configure(with: placeholder)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupSelf()
    }
    
    private func configure(with placeholder: String) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                         NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }
    
    private func setupSelf() {
        backgroundColor = .lightGrayColor
        leftView = leftPaddingView
        leftPaddingView.backgroundColor = .clear
        leftPaddingView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        leftViewMode = .always
        font = .font(style: .label)
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
    }
}
