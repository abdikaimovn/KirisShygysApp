//
//  ProfileViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.02.2024.
//

import UIKit

final class ServicesViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
    }
    
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
    }

}

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.typeName, for: indexPath) as? MenuTableViewCell {
            switch indexPath.row {
            case 0:
                cell.configure(
                    UIImage(systemName:"doc"),
                    "transactionReport_label".localized,
                    .lightGrayColor)
            case 1:
                cell.configure(
                    UIImage(systemName: "chart.bar.xaxis"),
                    "statistics_label".localized,
                    .lightGrayColor)
            case 2:
                cell.configure(
                    UIImage(systemName: "gear"),
                    "settings_label".localized,
                    .lightGrayColor)
            case 3:
                cell.configure(
                    UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                    "logout_label".localized,
                    .lightBrownColor)
            default:
                break
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
}
