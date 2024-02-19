//
//  HistoryPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 18.02.2024.
//

protocol HistoryViewProtocol: AnyObject {
    
}

final class HistoryPresenter {
    weak var view: HistoryViewProtocol?
    private var transactionData: [ValidatedTransactionModel]
    
    init(transactionData: [ValidatedTransactionModel]) {
        self.transactionData = transactionData
    }
    
    func viewDidLoaded() {
        
    }
    
    func numberOfRowsInSection() -> Int {
        transactionData.count
    }
    
    func dataForRowAt(_ index: Int) -> ValidatedTransactionModel {
        transactionData[index]
    }
}
