//
//  ExtendedTapAreaButton.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 03.02.2024.
//

import UIKit

final class ExtendedTapAreaButton: UIButton {
    private let dx: CGFloat
    private let dy: CGFloat
    
    init(dx: CGFloat, dy: CGFloat) {
        self.dx = dx
        self.dy = dy
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        self.dx = -20
        self.dy = -20
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // Увеличиваем область нажатия без изменения фрейма
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let increasedBounds = bounds.insetBy(dx: dx, dy: dy)
        return increasedBounds.contains(point)
    }
}
