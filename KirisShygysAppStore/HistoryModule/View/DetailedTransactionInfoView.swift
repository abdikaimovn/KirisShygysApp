//
//  DetailedTransactionView.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 20.02.2024.
//

import UIKit
import SnapKit

final class DetailedTransactionInfoView: UIView {
    private var transactionInfo: ValidatedTransactionModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(transactionModel: ValidatedTransactionModel) {
        transactionInfo = transactionModel
        
        infoTableView.reloadData()
    }
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let infoTableView = UITableView()
    
    private func setupTableView() {
        infoTableView.backgroundColor = .clear
        infoTableView.separatorStyle = .none
        infoTableView.register(DetailedTableViewCell.self, forCellReuseIdentifier: DetailedTableViewCell.typeName)
        infoTableView.showsVerticalScrollIndicator = false
        infoTableView.isScrollEnabled = true
        infoTableView.dataSource = self
    }
    
    private func setupView() {
        self.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalToSuperview()
        }
        
        infoView.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(50)
            make.top.equalToSuperview().offset(15)
        }
        
        infoView.addSubview(infoTableView)
        infoTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(logoImage.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        setupTableView()
    }
}

extension DetailedTransactionInfoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let safeInfo = transactionInfo else {
            return UITableViewCell()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: DetailedTableViewCell.typeName, for: indexPath) as? DetailedTableViewCell {
            let transactionType = safeInfo.transactionType == .expense ? "expenses_label".localized : "incomes_label".localized
            
            switch indexPath.row {
            case 0:
                cell.configure(transactionKey: "transactionType_label".localized, transactionValue: transactionType)
            case 1:
                cell.configure(transactionKey: "transactionName_label".localized,  transactionValue: safeInfo.transactionName)
            case 2:
                cell.configure(transactionKey: "transactionAmount_label".localized, transactionValue: "\(String.currentCurrency) \(safeInfo.transactionAmount)")
            case 3:
                cell.configure(transactionKey: "transactionDate_label".localized,  transactionValue: safeInfo.transactionDate)
            case 4:
                cell.configure(transactionKey: "transactionDescription_label".localized, transactionValue: safeInfo.transactionDescription)
            default:
                break
            }
            
            return cell
        }
    
        return UITableViewCell()
    }
}
