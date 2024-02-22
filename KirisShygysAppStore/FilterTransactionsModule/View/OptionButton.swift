//
//  OptionButton.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.02.2024.
//

import UIKit

final class OptionButton: UIButton {
    private let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupButton() {
        backgroundColor = .clear
        layer.cornerRadius = 5
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        layer.cornerCurve = .continuous
        layer.borderColor = UIColor.brownColor.cgColor
        layer.borderWidth = 1
        contentHorizontalAlignment = .center
    }
}
