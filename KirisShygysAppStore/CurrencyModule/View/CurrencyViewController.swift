//
//  CurrencyViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 03.03.2024.
//

import UIKit
import SnapKit

final class CurrencyViewController: UIViewController {
    private let presenter: CurrencyPresenter
    
    init(presenter: CurrencyPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: UI Elements
    private let сurrenciesTableView = SelfSizingTableView()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.viewDidLoaded()
    }
    
    //MARK: - Functions
    private func setupNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .brownColor
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    private func setupMenuTableView() {
        сurrenciesTableView.delegate = self
        сurrenciesTableView.dataSource = self
        сurrenciesTableView.separatorStyle = .none
        сurrenciesTableView.showsVerticalScrollIndicator = false
        сurrenciesTableView.backgroundColor = .clear
        сurrenciesTableView.isScrollEnabled = false
        сurrenciesTableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.typeName)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "currency_label".localized
        
        view.addSubview(сurrenciesTableView)
        сurrenciesTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        setupMenuTableView()
    }
}

extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.typeName, for: indexPath) as? CurrencyTableViewCell {
            cell.configure(with: presenter.dataForCell(at: indexPath.row))
            return cell
        }
        
        return UITableViewCell()
    }
}

extension CurrencyViewController: CurrencyViewProtocol {
    func showCurrencyChangeAlert() {
        AlertManager.showAlertWithChoise(on: self, title: "languageWarning_title".localized, message: "currencyWarning_label".localized) { [weak self] needToChange in
            guard let self else { return }
            
            self.presenter.userReplies(needToChange: needToChange)
        }
    }
    
    func updateView() {
        sceneDelegate?.updateRootView()
    }
}
