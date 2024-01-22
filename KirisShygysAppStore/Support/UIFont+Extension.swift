//
//  UIFont+Extension.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.01.2024.
//

import UIKit

extension UIFont {
    static func defaultFont() -> UIFont {
        let fontSize: CGFloat = 16.0
        
        guard let font = UIFont(name: "Roboto Light", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize)
        }

        return font
    }
    
    static func defaultButtonFont() -> UIFont {
        let fontSize: CGFloat = 18.0
        
        guard let font = UIFont(name: "Roboto Bold", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize, weight: .bold)
        }
        

        return font
    }
    
    static func defaultBoldFont() -> UIFont {
        let fontSize: CGFloat = 16.0
        
        guard let font = UIFont(name: "Roboto Bold", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize, weight: .bold)
        }

        return font
    }
    
    static func largeTitleFont() -> UIFont {
        let fontSize: CGFloat = 28.0

        guard let font = UIFont(name: "Roboto Medium", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize, weight: .bold)
        }
        
        return font
    }
}
