//
//  QuoteCollectionViewCell.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 23.02.2024.
//

import UIKit

final class QuoteCollectionViewCell: UICollectionViewCell {
    private let quotes = [
        QuoteModel(quote: "aiyaz_uddin_quote".localized, author: "- Aiyaz Uddin"),
        QuoteModel(quote: "linsey_mill_quote".localized, author: "- Linsey Mill"),
        QuoteModel(quote: "oscar_wilde_quote".localized, author: "- Oscar Wilde"),
        QuoteModel(quote: "robert_kiyosaki_quote1".localized, author: "– Robert Kiyosaki"),
        QuoteModel(quote: "suze_orman_quote".localized, author: "- Suze Orman"),
        QuoteModel(quote: "robert_kiyosaki_quote2".localized, author: "– Robert Kiyosaki"),
        QuoteModel(quote: "alan_greenspan_quote".localized, author: "- Alan Greenspan"),
        QuoteModel(quote: "robert_kiyosaki_quote3".localized, author: "- Robert Kiyosaki"),
        QuoteModel(quote: "benjamin_franklin_quote".localized, author: "- Benjamin Franklin"),
        QuoteModel(quote: "orrin_woodward_quote".localized, author: "- Orrin Woodward"),
        QuoteModel(quote: "asanali_ashimov_quote".localized, author: "- Asanali Ashimov"),
        QuoteModel(quote: "margulan_seisembai_quote".localized, author: "- Margulan Seisembai"),
        QuoteModel(quote: "qazaq_quote1".localized, author: "- Kazakh Quote"),
        QuoteModel(quote: "qazaq_quote2".localized, author: "- Kazakh Quote"),
        QuoteModel(quote: "qazaq_quote3".localized, author: "- Kazakh Quote"),
        QuoteModel(quote: "qazaq_quote4".localized, author: "- Kazakh Quote")
    ]
    
    private let monthQuoteLabel: UILabel = {
        let label = UILabel()
        label.text = "quoteTitle_label".localized
        label.textColor = .lightGrayColor
        label.font = .font(style: .label)
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
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupView() {
        let randomQuote = Int.random(in: quotes.indices)
        quoteLabel.text = quotes[randomQuote].quote
        quoteAuthor.text = quotes[randomQuote].author
        
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
