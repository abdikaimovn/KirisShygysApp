//
//  Date+Extension.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 19.02.2024.
//

import Foundation

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? self
    }
}
