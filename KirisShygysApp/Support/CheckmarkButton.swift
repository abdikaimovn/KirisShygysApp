//
//  CheckmarkButton.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 18.04.2024.
//

import UIKit

final class CheckmarkButton: UIButton {
    private let checkMarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .brownColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupView() {
        setImage(UIImage(systemName: "checkmark"), for: .normal)
        tintColor = .clear
        layer.cornerRadius = 5
        layer.cornerCurve = .continuous
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
    
    func didTapped() {
        tintColor = tintColor == UIColor.clear ? UIColor.brownColor : UIColor.clear
    }
}
