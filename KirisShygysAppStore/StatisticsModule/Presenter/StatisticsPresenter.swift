//
//  StatisticsPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 27.02.2024.
//

import UIKit
import DGCharts

protocol StatisticsViewProtocol: AnyObject {
    func setupChart(with model: ChartModel)
    func updateView(with color: UIColor)
    func showAbsenceDataView(withColor color: UIColor)
}

final class StatisticsPresenter {
    weak var view: StatisticsViewProtocol?
    private let transactionsData: [ValidatedTransactionModel]
    private var incomeChartModel: ChartModel?
    private var expenseChartModel: ChartModel?
    private var flowModel: [FlowModel]?
    
    init(transactionsData: [ValidatedTransactionModel]) {
        self.transactionsData = transactionsData
    }
    
    func viewDidLoaded(_ segmentedControlIndex: Int) {
        let transactionType: TransactionType = segmentedControlIndex == 0 ? .income : .expense
        configureChartData(transactionType)
        flowModel = calculateFlowModel()
    }
    
    func numberOfRowsInFlowModel() -> Int {
        calculateFlowModel().count
    }
    
    func dataForRowAt(_ index: Int) -> FlowModel {
        flowModel?[index] ?? FlowModel(value: 0, flowImage: .income)
    }
    
    private func calculateFlowModel() -> [FlowModel] {
        let incomes = transactionsData.filter({ $0.transactionType == .income }).reduce(0) { partialResult, transaction in
            return partialResult + transaction.transactionAmount
        }
        
        let expenses = transactionsData.filter({ $0.transactionType == .expense }).reduce(0) { partialResult, transaction in
            return partialResult + transaction.transactionAmount
        }
        
        let total = transactionsData.reduce(0) { partialResult, transaction in
            return partialResult + transaction.transactionAmount
        }
        
        var flowModel = [FlowModel]()
        flowModel.append(FlowModel(value: incomes, flowImage: .income))
        flowModel.append(FlowModel(value: expenses, flowImage: .expense))
        flowModel.append(FlowModel(value: total, flowImage: .total))
        
        return flowModel
    }
    
    func segmentedControlDidChanged(_ segmentedControlIndex: Int) {
        let transactionType: TransactionType = segmentedControlIndex == 0 ? .income : .expense
        
        if transactionType == .income {
            guard let safeIncomeChartModel = incomeChartModel else {
                configureChartData(transactionType)
                return
            }
            configureChart(with: safeIncomeChartModel, and: .incomeColor)
        } else {
            guard let safeExpenseChartModel = expenseChartModel else {
                configureChartData(transactionType)
                return
            }
            configureChart(with: safeExpenseChartModel, and: .expenseColor)
        }
    }
    
    private func configureChartData(_ transactionType: TransactionType) {
        let chartColor: UIColor = transactionType == .income ? .incomeColor : .expenseColor
        
        ChartHandler.configureChart(with: transactionsData, and: transactionType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let chartModel):
                if transactionType == .income {
                    self.incomeChartModel = chartModel
                } else {
                    self.expenseChartModel = chartModel
                }
                self.configureChart(with: chartModel, and: chartColor)
            case .failure(_):
                self.view?.showAbsenceDataView(withColor: chartColor)
            }
        }
    }
    
    private func configureChart(with model: ChartModel, and color: UIColor) {
        view?.setupChart(with: model)
        view?.updateView(with: color)
    }
}
