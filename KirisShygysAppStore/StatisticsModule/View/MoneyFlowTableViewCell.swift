//
//  MoneyFlowTableViewCell.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 27.02.2024.
//

import UIKit
import SnapKit

final class MoneyFlowTableViewCell: UITableViewCell {
    private let viewImage: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 6
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let flowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let flowLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body, withSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let flowValue: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body, withSize: 14)
        label.textColor = .black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(with model: FlowModel) {
        switch model.flowImage {
        case .income:
            flowImage.image = UIImage(systemName: model.flowImage.rawValue)
            flowLabel.text = "incomes_label".localized
            flowValue.text = "\("currency".localized) \(model.value)"
            flowValue.textColor = .incomeColor
        case .expense:
            flowImage.image = UIImage(systemName: model.flowImage.rawValue)
            flowLabel.text = "expenses_label".localized
            flowValue.text = "\("currency".localized) \(model.value)"
            flowValue.textColor = .expenseColor
        case .total:
            flowImage.image = UIImage(systemName: model.flowImage.rawValue)
            flowLabel.text = "total_label".localized
            flowValue.text = "\("currency".localized) \(model.value)"
        }
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(flowImage)
        flowImage.setContentCompressionResistancePriority(.required, for: .horizontal)
        flowImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(5)
            make.size.equalTo(25)
        }
        
        contentView.addSubview(flowLabel)
        flowLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        flowLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowImage.snp.trailing).offset(10)
            make.centerY.equalTo(flowImage.snp.centerY)
        }
        
        contentView.addSubview(flowValue)
        flowValue.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(flowLabel.snp.centerY)
            make.leading.greaterThanOrEqualTo(flowLabel.snp.trailing).offset(10)
        }
    }
}
