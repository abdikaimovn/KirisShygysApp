//
//  StoryCollectionViewCell.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 23.02.2024.
//

import UIKit
import SnapKit

final class StoryCollectionViewCell: UICollectionViewCell {
    //MARK: - UI Elements
    private let thisMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "thisMonthTitle_label".localized
        label.textColor = .lightGrayColor
        label.font = .font(style: .label)
        label.textAlignment = .center
        return label
    }()
    
    private let transactionType: UILabel = {
        let label = UILabel()
        label.font = .font(style: .regularLarge)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .large)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        return view
    }()
    
    private let biggestTransactionLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .label, withSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let biggestTransactionView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrayColor
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let biggestTransactionName: UILabel = {
        let label = UILabel()
        label.font = .font(style: .label)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let biggestTransactionAmount: UILabel = {
        let label = UILabel()
        label.font = .font(style: .large)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Functions
    func configure(reportModel: ReportModel) {
        //hide container if there is an empty amount of money
        containerView.isHidden = reportModel.isEmptyAmount
        
        transactionType.text = reportModel.transactionType
        amountLabel.text = reportModel.amount
        biggestTransactionLabel.text = reportModel.biggestTransactionLabel
        biggestTransactionName.text = reportModel.biggestTransactionName
        biggestTransactionAmount.text = reportModel.biggestTransactionAmount
    }
    
    private func setupView() {
        contentView.addSubview(thisMonthLabel)
        thisMonthLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        thisMonthLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.greaterThanOrEqualToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(transactionType)
        transactionType.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.greaterThanOrEqualToSuperview().offset(20)
            make.top.equalTo(thisMonthLabel.snp.bottom).offset(60)
        }
        transactionType.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(transactionType.snp.bottom).offset(10)
        }
        amountLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(amountLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
        
        containerView.addSubview(biggestTransactionLabel)
        biggestTransactionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(biggestTransactionView)
        biggestTransactionView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        biggestTransactionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(biggestTransactionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        biggestTransactionView.addSubview(biggestTransactionName)
        biggestTransactionName.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
   
        containerView.addSubview(biggestTransactionAmount)
        biggestTransactionAmount.snp.makeConstraints { make in
            make.top.equalTo(biggestTransactionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        biggestTransactionAmount.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
