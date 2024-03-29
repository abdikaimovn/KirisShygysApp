//
//  LanguageViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 29.02.2024.
//

import UIKit
import SnapKit

final class LanguageViewController: UIViewController {
    private let presenter: LanguagePresenter
    private var successAnimationView: SuccessAnimationView?
    
    //MARK: UI Elements
    private let languagesTableView = SelfSizingTableView()
    
    //MARK: - Lifecycle
    init(presenter: LanguagePresenter) {
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
    
    private func setupAnimationView() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        successAnimationView = SuccessAnimationView(frame: view.frame)
        
        guard let safeAnimationView = successAnimationView else {
            return
        }
        
        safeAnimationView.parent = self
        
        view.addSubview(safeAnimationView)
        safeAnimationView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
    }
    
    private func setupMenuTableView() {
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
        languagesTableView.separatorStyle = .none
        languagesTableView.showsVerticalScrollIndicator = false
        languagesTableView.backgroundColor = .clear
        languagesTableView.isScrollEnabled = false
        languagesTableView.register(LanguageTableViewCell.self, forCellReuseIdentifier: LanguageTableViewCell.typeName)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "language_label".localized
        
        view.addSubview(languagesTableView)
        languagesTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        setupMenuTableView()
    }
}

extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LanguageTableViewCell.typeName, for: indexPath) as? LanguageTableViewCell {
            cell.configure(with: presenter.dataForCell(at: indexPath.row))
            return cell
        }
        
        return UITableViewCell()
    }
}

extension LanguageViewController: LanguageViewProtocol {
    func updateView() {
        setupAnimationView()
        
        successAnimationView?.playAnimation()
    }
    
    func showLanguageChangeAlert() {
        AlertManager.showAlertWithChoise(on: self, message: "languageWarning_label".localized) { [weak self] needToChange in
            guard let self else { return }
            
            self.presenter.userReplies(needToChange: needToChange)
        }
    }
}

extension LanguageViewController: SuccessAnimationDelegate {
    func restartDidTapped() {
        sceneDelegate?.showInitialModule()
    }
}
