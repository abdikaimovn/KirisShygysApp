//
//  FilterModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 19.02.2024.
//

import Foundation

struct FilterModel {
    var filterBy: TransactionType?
    var sortBy: SortByEnum?
    var period: PeriodEnum?
}

enum SortByEnum {
    case newest, oldest
}

enum PeriodEnum {
    case week, month, halfyear, year
}
