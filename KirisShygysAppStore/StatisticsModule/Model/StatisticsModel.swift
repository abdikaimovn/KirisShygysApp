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
