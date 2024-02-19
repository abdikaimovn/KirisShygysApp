//
//  HistoryModel.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 19.02.2024.
//

import Foundation

struct SectionTitleModel {
    var fullDate: String
    
    var sectionTitleDate: String {
        return String(fullDate.prefix(10))
    }
}
