//
//  BackgroundView.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 08.03.2024.
//

import UIKit
import SnapKit

final class CustomView: UIView {
    private let itemImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        image.tintColor = .black
        return image
    }()
    
    private let itemTitle: UILabel = {
        let label = UILabel()
        label.font = .font(style: .label)
        label.textColor = .black
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
        setupSubviews()
    }
    
    func configure(imageName: String, title: String) {
        itemImage.image = UIImage(systemName: imageName)
        itemTitle.text = title
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 1, height: 4)
        layer.shadowRadius = 15
        layer.shadowColor = UIColor.black.cgColor
    }
    
    private func setupSubviews() {
        addSubview(itemImage)
        itemImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.size.equalTo(25)
        }
        
        addSubview(itemTitle)
        itemTitle.snp.makeConstraints { make in
            make.leading.equalTo(itemImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(itemImage.snp.centerY)
        }
    }
}
