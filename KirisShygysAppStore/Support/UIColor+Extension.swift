//
//  UIColor+Extension.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.01.2024.
//

import Foundation
import UIKit

// Extensing UIColor class to adopt HEX colors
extension UIColor {
    convenience init?(hex: String) {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgbValue: UInt64 = 0
        
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        
        if formattedHex.count == 6 {
            formattedHex = "FF" + formattedHex
        }
        
        if let red = UInt8(exactly: (rgbValue & 0xFF0000) >> 16),
           let green = UInt8(exactly: (rgbValue & 0x00FF00) >> 8),
           let blue = UInt8(exactly: (rgbValue & 0x0000FF) >> 0) {
                self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        } else {
            return nil
        }
    }
    
    static var brownColor: UIColor {
        UIColor(hex: "#C7B08E") ?? .brown
    }
    
    static var expenseColor: UIColor {
        UIColor(hex: "#E94D58") ?? .red
    }
    
    static var incomeColor: UIColor {
        UIColor(hex: "#2BA478") ?? .green
    }
    
    static var lightGrayColor: UIColor {
        UIColor(hex: "#f9f9f9") ?? .lightGray
    }
    
    static var grayColor: UIColor {
        UIColor(hex: "#e0e0e0") ?? .lightGray
    }
    
    static var lightBrownColor: UIColor {
        UIColor(hex: "#ddd0bb") ?? .brown
    }

}
