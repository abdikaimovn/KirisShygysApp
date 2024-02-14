//
//  TransactionTableViewCell.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 11.02.2024.
//

import UIKit
import SnapKit

final class TransactionTableViewCell: UITableViewCell {
    private let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .lightGrayColor
        return view
    }()
    
    private let viewImage: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "square.and.arrow.up")
        image.tintColor = .white
        image.backgroundColor = .clear
        return image
    }()
    
    private let transName: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private let purchasedData: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body, withSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .title)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(transactionData: TransactionModel) {
        let currentData = Date.now.formatted().prefix(10)
        
        transName.text = transactionData.transactionName
        priceLabel.text = "\("currency".localized) \(transactionData.transactionAmount ?? 1.0)"
        priceLabel.textColor = transactionData.transactionType == .income ? UIColor.incomeColor : UIColor.expenseColor
        purchasedData.text = transactionData.transactionDate!.prefix(10) == currentData ? "today_label".localized : String(transactionData.transactionDate!.prefix(10))
        viewImage.backgroundColor = priceLabel.textColor
        image.image = transactionData.transactionType == .income ? UIImage(systemName: "square.and.arrow.down") : UIImage(systemName: "square.and.arrow.up")
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        mainView.addSubview(viewImage)
        viewImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(50)
        }
        
        viewImage.addSubview(image)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        mainView.addSubview(transName)
        transName.snp.makeConstraints { make in
            make.leading.equalTo(viewImage.snp.trailing).offset(15)
            make.top.equalTo(viewImage.snp.top)
        }
    
        mainView.addSubview(purchasedData)
        purchasedData.snp.makeConstraints { make in
            make.leading.equalTo(viewImage.snp.trailing).offset(15)
            make.bottom.equalTo(viewImage.snp.bottom)
        }
        
        mainView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(transName.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
