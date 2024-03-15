//
//  AbsenceDataView.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 27.02.2024.
//

import UIKit
import SnapKit

final class AbsenceDataView: UIView {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "chart.bar.xaxis")
        return view
    }()
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body, withSize: 14)
        label.text = "noTransaction".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func showView(withColor color: UIColor) {
        imageView.tintColor = color
        isHidden = false
    }
    
    func hideView() {
        isHidden = true
    }
    
    private func setupView() {
        backgroundColor = .white
        
        isHidden = true
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().dividedBy(4)
        }
        
        addSubview(noDataLabel)
        noDataLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
    }
}

