//
//  SettingsViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 29.02.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let presenter: SettingsPresenter
    
    //MARK: UI Elements
    private let menuTableView = SelfSizingTableView()
    
    //MARK: - Lifecycle
    init(presenter: SettingsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .brownColor
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    private func setupMenuTableView() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorStyle = .none
        menuTableView.showsVerticalScrollIndicator = false
        menuTableView.backgroundColor = .clear
        menuTableView.isScrollEnabled = false
        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.typeName)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "settings_label".localized
        
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        setupMenuTableView()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.typeName) as? MenuTableViewCell {
            cell.settingsConfigure(with: presenter.dataForItemAt(indexPath.row))
            return cell
        }
        
        return UITableViewCell()
    }
}

extension SettingsViewController: SettingsViewProtocol {
    
}

