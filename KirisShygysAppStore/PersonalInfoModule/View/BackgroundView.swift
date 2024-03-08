//
//  BackgroundView.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 08.03.2024.
//

import UIKit
import SnapKit

final class BackgroundView: UIView {
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
            make.leading.top.equalToSuperview().inset(10)
            make.size.equalTo(25)
            
        }
    }
}
