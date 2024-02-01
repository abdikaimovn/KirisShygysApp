//
//  LoaderView.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

import UIKit
import SnapKit

final class LoaderView: UIView {
    private let loader = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(with: .large)
    }
    
    init(with style: UIActivityIndicatorView.Style) {
        super.init(frame: .zero)
        setupView(with: style)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func showLoader() {
        isHidden = false
    }
    
    func hideLoader() {
        isHidden = true
    }
    
    private func setupView(with style: UIActivityIndicatorView.Style) {
        backgroundColor = .lightGrayColor
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous
        isHidden = true
        
        addSubview(loader)
        loader.style = style
        loader.color = .darkGray
        
        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loader.startAnimating()
    }
}
