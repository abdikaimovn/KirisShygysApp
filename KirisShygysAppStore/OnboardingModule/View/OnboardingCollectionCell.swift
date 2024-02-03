//
//  OnboardingCollectionCell.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.01.2024.
//

import UIKit

final class OnboardingCollectionCell: UICollectionViewCell {
    //MARK: - UI Elements
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.font(style: .regularLarge)
        title.textColor = .black
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont.font(style: .body)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(onboardingModel: OnboardingModel) {
        imageView.image = onboardingModel.image
        titleLabel.text = onboardingModel.title
        descriptionLabel.text = onboardingModel.description
    }
    
    private func setupViews() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }

        addSubview(titleLabel)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(imageView.snp.bottom).offset(30)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
}
