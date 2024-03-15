//
//  SelfSizingTableView.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.02.2024.
//

import UIKit

final class SelfSizingTableView: UITableView {

    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return contentSize
    }

}
