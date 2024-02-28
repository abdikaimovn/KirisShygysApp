//
//  StatisticsModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 27.02.2024.
//

import DGCharts
import UIKit

enum MoneyFlowEnum: String {
    case income = "square.and.arrow.down"
    case expense = "square.and.arrow.up"
    case total = "dollarsign.arrow.circlepath"
}

struct FlowModel {
    let value: Int
    let flowImage: MoneyFlowEnum
}

struct GroupedTransaction {
    let value: Int
    let date: String
}

struct ChartModel {
    let xAxisTitles: [String]
    let chartData: BarChartDataSet
}

enum ChartError: Error {
    case noTransactions
}

struct ChartHandler {
    static func configureChart(with data: [ValidatedTransactionModel], and type: TransactionType, completion: (Result<ChartModel, ChartError>) -> ()){
        var groupedTransactions = [String: Int]()
        var countOfTransactionType = 0
        
        //Проходим по массиву и суммируя группируем транзакций по датам
        data.forEach { transaction in
            if type == transaction.transactionType {
                let transactionDate = String(transaction.transactionDate.prefix(10))
                
                groupedTransactions[transactionDate, default: 0] += transaction.transactionAmount
                
                countOfTransactionType += 1
            }
        }
        
        guard countOfTransactionType != 0 else {
            let color = type == .income ? UIColor.incomeColor : UIColor.expenseColor
            completion(.failure(.noTransactions))
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
        
        completion(.success(ChartModel(xAxisTitles: xValues, chartData: dataSet)))
    }
}
