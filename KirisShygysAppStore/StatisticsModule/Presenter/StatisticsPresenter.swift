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
        configureChartData(segmentedControlIndex)
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
        let type: TransactionType = segmentedControlIndex == 0 ? .income : .expense
        
        if type == .income {
            guard let safeIncomeChartModel = incomeChartModel else {
                configureChartData(segmentedControlIndex)
                return
            }
            view?.setupChart(with: safeIncomeChartModel)
            view?.updateView(with: .incomeColor)
        } else {
            guard let safeExpenseChartModel = expenseChartModel else {
                configureChartData(segmentedControlIndex)
                return
            }
            view?.setupChart(with: safeExpenseChartModel)
            view?.updateView(with: .expenseColor)
        }
    }
    
    private func configureChartData(_ segmentedControlIndex: Int) {
        let type: TransactionType = segmentedControlIndex == 0 ? .income : .expense
        
        var groupedTransactions = [String: Int]()
        var countOfTransactionType = 0
        
        //Проходим по массиву и суммируя группируем транзакций по датам
        transactionsData.forEach { transaction in
            if type == transaction.transactionType {
                let transactionDate = String(transaction.transactionDate.prefix(10))
                
                groupedTransactions[transactionDate, default: 0] += transaction.transactionAmount
                
                countOfTransactionType += 1
            }
        }
        
        guard countOfTransactionType != 0 else {
            let color = type == .income ? UIColor.incomeColor : UIColor.expenseColor
            view?.showAbsenceDataView(withColor: color)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate)!
        
        //Высчитываем данные для label оси x
        var lastMonthDates = [String]()
        var currentDate = startDate
        
        while currentDate <= endDate {
            lastMonthDates.append(dateFormatter.string(from: currentDate))
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        var entries = [BarChartDataEntry]()
        for (index, element) in lastMonthDates.enumerated() {
            if let safeValue = groupedTransactions[element] {
                entries.append(BarChartDataEntry(x: Double(index), y: Double(safeValue)))
            } else {
                entries.append(BarChartDataEntry(x: Double(index), y: 0))
            }
        }
        
        let dataSet = BarChartDataSet(entries: entries)
        
        // Так как даты у нас представлены как 'dd.MM.yyyy', извлекаем только дни месяца для показа
        let xValues = lastMonthDates.map {"\($0.prefix(2))"}
        
        let chartColor = type == .income ? UIColor.incomeColor : UIColor.expenseColor
        dataSet.setColor(chartColor)
        
        if type == .income {
            incomeChartModel = ChartModel(xAxisTitles: xValues, chartData: dataSet)
        } else {
            expenseChartModel = ChartModel(xAxisTitles: xValues, chartData: dataSet)
        }
        
        view?.setupChart(with: ChartModel(xAxisTitles: xValues, chartData: dataSet))
        view?.updateView(with: chartColor)
    }
}
