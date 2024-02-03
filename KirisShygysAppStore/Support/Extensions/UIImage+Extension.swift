//
//  UIImage+Extension.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 03.02.2024.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
