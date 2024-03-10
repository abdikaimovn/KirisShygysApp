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
    
    private let loaderView = LoaderView(with: .large)
    
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
    
    //MARK: - Functions
    private func setupView() {
        view.backgroundColor = .white
        title = "settings_label".localized
        
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        setupMenuTableView()
        
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(70)
        }
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
    
    private func createLanguageModule() -> UIViewController {
        let presenter = LanguagePresenter()
        let view = LanguageViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
    private func createPersonalInfoModule() -> UIViewController {
        let userDataservice = UserDataService()
        let authService = AuthenticationService()
        let presenter = PersonalInfoPresenter(userDataService: userDataservice, authenticationService: authService)
        let view = PersonalInfoViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath.row)
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
    func showPersonalInfoModule() {
        navigationController?.pushViewController(createPersonalInfoModule(), animated: true)
    }
    
    func updateView() {
        sceneDelegate?.updateRootView()
    }
    
    func showAlertWithChoise(_ title: String, _ message: String) {
        AlertManager.showAlertWithChoise(on: self, title: title, message: message) { [weak self] needToDelete in
            guard let self else { return }
            
            self.presenter.userReplies(needToDelete)
        }
    }
    
    func showLanguageModule() {
        navigationController?.pushViewController(createLanguageModule(), animated: true)
    }
    
    func showFailure(_ failure: NetworkErrorModel) {
        AlertManager.showAlert(on: self, title: failure.title, message: failure.description)
    }
    
    func showLoader() {
        loaderView.showLoader()
    }
    
    func hideLoader() {
        loaderView.hideLoader()
    }
}

