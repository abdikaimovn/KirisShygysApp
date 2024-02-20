//
//  DetailedTableViewCell.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 20.02.2024.
//

import UIKit

final class DetailedTableViewCell: UITableViewCell {
    private let transactionKeyLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.font = .font(style: .title)
        return label
    }()
    
    private let transactionValueLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .font(style: .body)
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    func configure(transactionKey: String, transactionValue: String) {
        transactionKeyLabel.text = transactionKey
        transactionValueLabel.text = transactionValue.isEmpty ? "emptyDescription".localized : transactionValue
    }
    
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(transactionKeyLabel)
        transactionKeyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
        }
        
        transactionKeyLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        contentView.addSubview(transactionValueLabel)
        transactionValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(transactionKeyLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        transactionValueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        transactionValueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

}
