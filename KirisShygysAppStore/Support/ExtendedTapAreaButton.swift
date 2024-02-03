//
//  ExtendedTapAreaButton.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 03.02.2024.
//

import UIKit

final class ExtendedTapAreaButton: UIButton {

    // Увеличиваем область нажатия без изменения фрейма
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let increasedBounds = bounds.insetBy(dx: -20, dy: -20)
        return increasedBounds.contains(point)
    }
}
