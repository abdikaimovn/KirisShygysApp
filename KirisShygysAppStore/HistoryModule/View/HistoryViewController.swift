//
//  HistoryViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 18.02.2024.
//

import UIKit
import SnapKit

final class HistoryViewController: UIViewController {
    private let presenter: HistoryPresenter
    
    private let filterTransactionLabel: UILabel = {
        let label = UILabel()
        label.text = "filterTransactions_label".localized
        label.font = .font(style: .body)
        label.textColor = .black
        return label
    }()
    
    private let filterButton = UIButton()
    
    private let transactionsTableView = UITableView()
    
    init(presenter: HistoryPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .brownColor
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupFilterButton()
        setupTransactionsTableView()
    }
    
    private func setupTransactionsTableView() {
        transactionsTableView.backgroundColor = .clear
        transactionsTableView.separatorStyle = .none
        transactionsTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.typeName)
        transactionsTableView.showsVerticalScrollIndicator = false
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
    }

    private func setupFilterButton() {
        filterButton.setImage(UIImage(systemName: "slider.vertical.3"), for: .normal)
        filterButton.backgroundColor = .lightGrayColor
        filterButton.layer.cornerRadius = 10
        filterButton.layer.cornerCurve = .continuous
        filterButton.tintColor = .brownColor
        filterButton.addTarget(self, action: #selector(showFilters), for: .touchUpInside)
    }
    
    @objc private func showFilters() {
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "history_label".localized
        
        view.addSubview(filterTransactionLabel)
        filterTransactionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.equalToSuperview().inset(40)
        }
        
        view.addSubview(filterButton)
        filterButton.snp.makeConstraints { make in
            make.centerY.equalTo(filterTransactionLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(40)
            make.leading.greaterThanOrEqualTo(filterTransactionLabel.snp.trailing).offset(20)
        }
        
        view.addSubview(transactionsTableView)
        transactionsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.top.equalTo(filterButton.snp.bottom).offset(10)
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.typeName, for: indexPath) as? HistoryTableViewCell {
            cell.configure(transactionData: presenter.dataForRowAt(indexPath.row))
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
}

extension HistoryViewController: HistoryViewProtocol {
    
}
