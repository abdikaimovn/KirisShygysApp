//
//  CurrencyTableViewCell.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 03.03.2024.
//

import UIKit
import SnapKit

final class CurrencyTableViewCell: UITableViewCell {
    //MARK: - UI Elements
    private let mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .lightGrayColor
        mainView.layer.cornerRadius = 10
        mainView.layer.cornerCurve = .continuous
        return mainView
    }()
    
    private let languageImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        image.tintColor = .brownColor
        return image
    }()
    
    private let languageNameLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .label)
        return label
    }()
    
    private let doneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .brownColor
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
    
    func configure(with model: CurrencyModel) {
        languageImage.image = model.currencyImage
        languageNameLabel.text = model.currencyName
        doneImageView.isHidden = !model.isSelected
    }
    
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        mainView.addSubview(languageImage)
        languageImage.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.leading.top.bottom.equalToSuperview().inset(12)
        }
        
        mainView.addSubview(languageNameLabel)
        languageNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(languageImage.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
        
        mainView.addSubview(doneImageView)
        doneImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(12)
            make.size.equalTo(25)
        }
    }
}
