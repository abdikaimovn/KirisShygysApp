//
//  LoaderView.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

import UIKit
import SnapKit

class LoaderView: UIView {
    private let loader = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoader(with style: UIActivityIndicatorView.Style) {
        addSubview(loader)
        loader.style = style
        loader.color = .darkGray
        
        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loader.startAnimating()
        
        isHidden = false
    }
    
    func hideLoader() {
        isHidden = true
    }
    
    private func setupView() {
        backgroundColor = .lightGrayColor
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous
        isHidden = true
    }
}
