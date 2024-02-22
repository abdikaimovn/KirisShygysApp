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
    func showFailure(with errorModel: NetworkErrorModel)
    func showAbsenceDataView()
    func hideAbsenceDataView()
    func hideDetailedTransactionInfo()
    func showDetailedTransactionInfo(with data: ValidatedTransactionModel)
}

final class HistoryPresenter {
    weak var view: HistoryViewProtocol?
    private let networkService: HistoryServiceProtocol
    private var transactionData: [ValidatedTransactionModel]
    
    private var groupedTransactions: [String: [ValidatedTransactionModel]] = [:]
    private var sectionTitles: [SectionTitleModel] = []
    private var filteredTransactionData: [ValidatedTransactionModel]
    
    init(transactionData: [ValidatedTransactionModel], networkService: HistoryServiceProtocol) {
        self.transactionData = transactionData
        self.networkService = networkService
        filteredTransactionData = transactionData
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
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        let sectionTitle = sectionTitles[indexPath.section].sectionTitleDate
        
        if let transactions = groupedTransactions[sectionTitle] {
            let transaction = transactions[indexPath.row]
            view?.showDetailedTransactionInfo(with: transaction)
        }
    }
    
    func closeTransactionInfoTapped() {
        view?.hideDetailedTransactionInfo()
    }
    
    func cellIsDeletingForRow(at indexPath: IndexPath) {
        let sectionTitle = sectionTitles[indexPath.section].sectionTitleDate
        let transactionToDelete = groupedTransactions[sectionTitle]?[indexPath.row]
        
        guard let transactionToDelete = transactionToDelete else {
            return
        }
        
        networkService.deleteTransaction(transactionData: transactionToDelete) { [weak self] result in
            switch result {
            case .success():
                break
            case .failure(let failure):
                self?.view?.showFailure(with: failure)
                return
            }
        }
        
        for (index, transaction) in filteredTransactionData.enumerated() {
            if transaction.id == transactionToDelete.id {
                filteredTransactionData.remove(at: index)
            }
        }
        
        for (index, transaction) in transactionData.enumerated() {
            if transaction.id == transactionToDelete.id {
                transactionData.remove(at: index)
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(NotificationCenterEnum.updateAfterDeletingTransaction.rawValue), object: nil)
        
        updateTransactions(filteredTransactionData)
        view?.reloadTransactionsTableView()
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
    
    func didGetFilterSettings(filterModel: FilterModel) {
        view?.showLoader()
        
        if filterModel.period == nil &&
            filterModel.filterBy == nil && 
            filterModel.sortBy == nil {
            updateTransactions(transactionData)
            view?.reloadTransactionsTableView()
            view?.hideLoader()
            return
        }
        
        let filter = TransactionFilter()
        filteredTransactionData = transactionData
        
        if let filterBy = filterModel.filterBy {
            filteredTransactionData = filter.applyFilterBy(filterBy: filterBy, transactionData: filteredTransactionData)
        }
        
        if let sortBy = filterModel.sortBy {
            filteredTransactionData = filter.applySortBy(sortBy: sortBy, transactionData: filteredTransactionData)
        }
        
        if let period = filterModel.period {
            filteredTransactionData = filter.applyTransactionsByPeriod(period: period, transactionData: filteredTransactionData)
        }
        
        updateTransactions(filteredTransactionData)
        view?.reloadTransactionsTableView()
        view?.hideLoader()
    }
    
    private func updateTransactions(_ data: [ValidatedTransactionModel]) {
        if data.isEmpty {
            view?.showAbsenceDataView()
        } else {
            view?.hideAbsenceDataView()
        }
        
        groupedTransactions = Dictionary(
            grouping: data,
            by: { String($0.transactionDate.prefix(10))}
        )
        
        sectionTitles = [SectionTitleModel]()
        
        var uniqueElementData = Set<String>()
        for element in data {
            if !uniqueElementData.contains(String(element.transactionDate.prefix(10))) {
                sectionTitles.append(SectionTitleModel(fullDate: element.transactionDate))
            }
            uniqueElementData.insert(String(element.transactionDate.prefix(10)))
        }
    }
    
    func viewDidLoaded() {
        view?.showLoader()
        updateTransactions(transactionData)
        view?.hideLoader()
    }
}
