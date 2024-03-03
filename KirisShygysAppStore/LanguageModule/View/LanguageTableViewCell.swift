//
//  LanguageTableViewCell.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 29.02.2024.
//

import UIKit
import SnapKit

final class LanguageTableViewCell: UITableViewCell {
    //MARK: - UI Elements
    private let mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .lightGrayColor
        mainView.layer.cornerRadius = 10
        mainView.layer.cornerCurve = .continuous
        return mainView
    }()
    
    private let languageImageLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .label)
        return label
    }()
    
    private let languageNameLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .label)
        return label
    }()
    
    private let doneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.image = UIImage(systemName: "checkmark")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(with model: LanguageModel) {
        languageImageLabel.text = model.languageImage
        languageNameLabel.text = model.languageName
        doneImageView.isHidden = !model.isSelected
    }
    
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        mainView.addSubview(languageImageLabel)
        languageImageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        mainView.addSubview(languageNameLabel)
        languageNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(languageImageLabel.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
        
        mainView.addSubview(doneImageView)
        doneImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.size.equalTo(25)
        }
    }
}
