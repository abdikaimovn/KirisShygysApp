//
//  HistoryPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 18.02.2024.
//

import Foundation

protocol HistoryViewProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    func reloadTransactionsTableView()
}

final class HistoryPresenter {
    weak var view: HistoryViewProtocol?
    private let transactionData: [ValidatedTransactionModel]
    private var changedTransactionData: [ValidatedTransactionModel]
    
    private var groupedTransactions: [String: [ValidatedTransactionModel]] = [:]
    private var sectionTitles: [SectionTitleModel] = []
    
    init(transactionData: [ValidatedTransactionModel]) {
        self.transactionData = transactionData
        changedTransactionData = transactionData
    }
    
    func numberOfSections() -> Int {
        sectionTitles.count
    }
    
    func titleForHeaderInSection(_ sectionIndex: Int) -> String? {
        let sectionTitle = sectionTitles[sectionIndex].sectionTitleDate
        
        return identifySectionTitle(sectionTitle)
    }
    
    func numberOfRowsInSection(_ sectionIndex: Int) -> Int {
        let sectionTitle = sectionTitles[sectionIndex].sectionTitleDate
        return groupedTransactions[sectionTitle]?.count ?? 0
    }
    
    func dataForRowAt(_ indexPath: IndexPath) -> ValidatedTransactionModel? {
        let sectionTitle = sectionTitles[indexPath.section].sectionTitleDate
        
        if let transactions = groupedTransactions[sectionTitle] {
            let transaction = transactions[indexPath.row]
            return transaction
        }
        
        return nil
    }
    
    private func identifySectionTitle(_ sectionTitle: String) -> String {
        switch sectionTitle {
        case Date.now.formatted().prefix(10):
            return "today_label".localized
        case Date().yesterday.formatted().prefix(10):
            return "yesterday_label".localized
        default:
            return sectionTitle
        }
    }
    
    func viewDidLoaded() {
        view?.showLoader()
        
        groupedTransactions = Dictionary(
            grouping: transactionData,
            by: { String($0.transactionDate.prefix(10))}
        )
        
        sectionTitles = [SectionTitleModel]()
        
        var uniqueElementDate = Set<String>()
        for element in transactionData {
            if !uniqueElementDate.contains(String(element.transactionDate.prefix(10))) {
                sectionTitles.append(SectionTitleModel(fullDate: element.transactionDate))
            }
            uniqueElementDate.insert(String(element.transactionDate.prefix(10)))
        }
        
        view?.hideLoader()
    }
}
