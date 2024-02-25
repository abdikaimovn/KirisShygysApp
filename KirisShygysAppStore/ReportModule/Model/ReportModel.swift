//
//  ReportModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 23.02.2024.
//

struct ReportModel {
    let transactionType: String
    let amount: String
    let biggestTransactionLabel: String
    let biggestTransactionName: String
    let biggestTransactionAmount: String
    let isEmptyAmount: Bool
}

struct QuoteModel {
    let quote: String
    let author: String
}

struct QuoteGenerator {
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
    
    var randomQuote: QuoteModel {
        quotes[Int.random(in: quotes.indices)]
    }
}

struct ReportInfo {
    let summa: Int
    let maxValue: Int
    let maxValueTitle: String
    let isEmptyAmount: Bool
}
