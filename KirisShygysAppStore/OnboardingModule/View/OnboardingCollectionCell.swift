//
//  OnboardingCollectionCell.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.01.2024.
//

import UIKit

final class OnboardingCollectionCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        var imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        var title = UILabel()
        title.font = UIFont.largeTitleFont()
        title.textColor = .black
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    private var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultFont()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(onboardingModel: OnboardingModel) {
        self.imageView.image = onboardingModel.image
        self.titleLabel.text = onboardingModel.title
        self.descriptionLabel.text = onboardingModel.description
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
