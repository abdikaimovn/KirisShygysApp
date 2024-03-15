//
//  QuoteCollectionViewCell.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 23.02.2024.
//

import UIKit
import SnapKit

final class QuoteCollectionViewCell: UICollectionViewCell {
    private let quoteGenerator = QuoteGenerator()
    
    private let monthQuoteLabel: UILabel = {
        let label = UILabel()
        label.text = "quoteTitle_label".localized.uppercased()
        label.textColor = .lightGrayColor
        label.font = .font(style: .title, withSize: 18)
        return label
    }()
    
    private let quoteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(style: .italicLarge)
        label.numberOfLines = 0
        return label
    }()
    
    private let quoteAuthor: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .font(style: .large)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureQuoteModel()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func configureQuoteModel() {
        let quote = quoteGenerator.randomQuote
        quoteLabel.text = quote.quote
        quoteAuthor.text = quote.author
    }
    
    private func setupView() {
        contentView.addSubview(monthQuoteLabel)
        monthQuoteLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(quoteLabel)
        quoteLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(monthQuoteLabel.snp.bottom).offset(50)
        }
        
        contentView.addSubview(quoteAuthor)
        quoteAuthor.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(quoteLabel.snp.bottom).offset(50)
        }
    }
}
