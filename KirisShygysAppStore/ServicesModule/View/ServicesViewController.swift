//
//  ProfileViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.02.2024.
//

import UIKit
import SnapKit

final class ServicesViewController: UIViewController {
    private let presenter: ServicesPresenter
    
    //MARK: - UI Elements
    private let menuLabel: UILabel = {
        let label = UILabel()
        label.text = "menu_label".localized
        label.font = .font(style: .large)
        label.textColor = .black
        return label
    }()
    
    private let menuTableView: UITableView = {
        let tableView = SelfSizingTableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.typeName)
        return tableView
    }()
    
    private let loaderView = LoaderView(with: .medium)
    
    //MARK: - Lifecycle
    init(presenter: ServicesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
    }
    
    //MARK: - Functions
    private func setupTableView() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }

    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(menuLabel)
        menuLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(menuLabel.snp.bottom).offset(10)
        }
        
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loaderView.backgroundColor = .white
    }

    private func createTransactionReportModule(_ transactionsData: [ValidatedTransactionModel]) -> UIViewController {
        let presenter = ReportPresenter(transactionsData: transactionsData)
        let view = ReportViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
    private func createStatisticsModule(_ transactionsData: [ValidatedTransactionModel]) -> UIViewController {
        let presenter = StatisticsPresenter(transactionsData: transactionsData)
        let view = StatisticsViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
    private func createSettingsModule() -> UIViewController {
        let service = UserDataService()
        let presenter = SettingsPresenter(userDataService: service)
        let view = SettingsViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.typeName, for: indexPath) as? MenuTableViewCell {
            cell.servicesConfigure(with: presenter.dataForItemAt(indexPath.row))
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
}

extension ServicesViewController: ServicesViewProtocol {
    func showNetworkFailure(_ failure: NetworkErrorModel) {
        AlertManager.showAlert(on: self, title: failure.title , message: failure.description)
    }
    
    func showError(_ error: ErrorModel) {
        AlertManager.showAlert(on: self, title: error.title , message: error.description)
    }
    
    func showTransactionReportModule(_ transactionsData: [ValidatedTransactionModel]) {
        navigationController?.pushViewController(createTransactionReportModule(transactionsData), animated: true)
    }
    
    func showStatisticsModule(_ transactionsData: [ValidatedTransactionModel]) {
        navigationController?.pushViewController(createStatisticsModule(transactionsData), animated: true)
    }
    
    func showSettingsModule() {
        navigationController?.pushViewController(createSettingsModule(), animated: true)
    }
    
    func logOut() {
        sceneDelegate?.showInitialModule()
    }
    
    func showLoader() {
        loaderView.showLoader()
    }
    
    func hideLoader() {
        loaderView.hideLoader()
    }
}
