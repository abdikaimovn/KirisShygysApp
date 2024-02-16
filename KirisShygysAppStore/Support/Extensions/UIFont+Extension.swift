//
//  UIFont+Extension.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.01.2024.
//

import UIKit

enum FontStyle {
    case body
    case title
    case label
    case mediumLabel
    case button
    case large
    case regularLarge
    
    var fontSize: CGFloat {
        switch self {
        case .body:
            return 16.0
        case .title:
            return 16.0
        case .label:
            return 18.0
        case .mediumLabel:
            return 18.0
        case .button:
            return 18.0
        case .large:
            return 28.0
        case .regularLarge:
            return 28.0
        }
    }
    
    var fontName: String {
        switch self {
        case .body:
            return "Roboto-Regular"
        case .title:
            return "Roboto Bold"
        case .label:
            return "Roboto-Regular"
        case .mediumLabel:
            return "Roboto Medium"
        case .button:
            return "Roboto Bold"
        case .large:
            return "Roboto Medium"
        case .regularLarge:
            return "Roboto-Regular"
        }
    }
}

extension UIFont {
    static func font(style: FontStyle) -> UIFont {
        UIFont(name: style.fontName, size: style.fontSize) ?? UIFont.systemFont(ofSize: style.fontSize)
    }
    
    static func font(style: FontStyle, withSize: CGFloat) -> UIFont {
        UIFont(name: style.fontName, size: withSize) ?? UIFont.systemFont(ofSize: withSize)
    }
}
