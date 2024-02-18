//
//  HomeViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

import UIKit

final class HomeViewController: UIViewController {
    private let presenter: HomePresenter
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBrownColor
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "welcome_label".localized
        label.font = .font(style: .body)
        label.textColor = .darkGray
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .title, withSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    private let card: UIView = {
        let card = UIView()
        card.backgroundColor = .brownColor
        card.layer.cornerRadius = 16
        card.layer.cornerCurve = .continuous
        card.clipsToBounds = true
        return card
    }()
    
    private let totalBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "totalBalance_label".localized
        label.font = .font(style: .label)
        label.textColor = .white
        return label
    }()
    
    private let totalBalance: UILabel = {
        let label = UILabel()
        label.font = .font(style: .mediumLabel, withSize: 30)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    //Income view
    private let incomeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private let income: UILabel = {
        let label = UILabel()
        label.text = "incomes_label".localized
        label.textColor = .white
        label.font = .font(style: .label)
        return label
    }()
    
    private let incomeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "square.and.arrow.down")
        image.tintColor = .white
        return image
    }()
    
    private let incomeLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .label)
        label.textColor = .white
        return label
    }()
    
    //Expense view
    private let expenseView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let expense: UILabel = {
        let label = UILabel()
        label.text = "expenses_label".localized
        label.font = .font(style: .label)
        label.textColor = .white
        return label
    }()
    
    private let expenseImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "square.and.arrow.up")
        image.tintColor = .white
        return image
    }()
    
    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .label)
        label.textColor = .white
        return label
    }()
    
    private let transactionsLabel: UILabel = {
        let label = UILabel()
        label.text = "transactions_label".localized
        label.font = .font(style: .mediumLabel)
        label.textColor = .black
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let btn = ExtendedTapAreaButton()
        btn.setTitle("history_label".localized, for: .normal)
        btn.titleLabel?.font =  .font(style: .label)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    //background view for transactionsTableView to handle its height properly on different devices
    private let backgroundViewOfTableView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .clear
        return backView
    }()
    
    private let transactionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = false
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.typeName)
        return tableView
    }()
    
    private let loaderView = LoaderView(with: .medium)
    
    //MARK: - Lifecycle
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //На данной стадии мы гарантируем что высота backgroundViewOfTableView будет объявлена
        setupTransactionTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSeeAllButton()
        setupNotificationCenter()
        
        presenter.viewDidLoaded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Functions
    private func setupTransactionTableView() {
        transactionsTableView.dataSource = self
        let tableViewHeight = Int(backgroundViewOfTableView.frame.height / 70) * 70
        
        backgroundViewOfTableView.addSubview(transactionsTableView)
        transactionsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.height.equalTo(tableViewHeight)
        }
    }
    
    private func setupSeeAllButton() {
        seeAllButton.addTarget(self, action: #selector(showAllTransactions), for: .touchUpInside)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateView),
            name: Notification.Name(NotificationCenterEnum.updateAfterTransaction.rawValue),
            object: nil
        )
    }
    
    @objc private func updateView() {
        presenter.viewDidLoaded()
    }
    
    //TODO: - Добавить показ историй транзакции
    @objc private func showAllTransactions() {
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        headerView.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        headerView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(2)
            make.leading.equalTo(welcomeLabel.snp.leading)
            make.trailing.equalToSuperview().inset(25)
        }
        
        headerView.addSubview(card)
        card.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(userNameLabel.snp.bottom).offset(20)
            make.centerY.equalTo(headerView.snp.bottom)
        }
        
        card.addSubview(totalBalanceLabel)
        totalBalanceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
        }
        
        card.addSubview(totalBalance)
        totalBalance.snp.makeConstraints { make in
            make.top.equalTo(totalBalanceLabel.snp.bottom).offset(5)
            make.leading.equalTo(totalBalanceLabel.snp.leading)
            make.trailing.equalToSuperview().inset(15)
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally

        card.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.top.equalTo(totalBalance.snp.bottom).offset(40)
        }
        
        // Income View
        stackView.addArrangedSubview(incomeView)

        incomeView.addSubview(incomeImage)
        incomeImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(5)
            make.size.equalTo(20)
        }

        incomeView.addSubview(income)
        income.snp.makeConstraints { make in
            make.leading.equalTo(incomeImage.snp.trailing).offset(5)
            make.centerY.equalTo(incomeImage.snp.centerY)
        }

        incomeView.addSubview(incomeLabel)
        incomeLabel.snp.makeConstraints { make in
            make.leading.equalTo(incomeImage.snp.leading).offset(2)
            make.top.equalTo(incomeImage.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }

        // Expense View
        stackView.addArrangedSubview(expenseView)

        expenseView.addSubview(expenseImage)
        expenseImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(5)
            make.size.equalTo(20)
        }

        expenseView.addSubview(expense)
        expense.snp.makeConstraints { make in
            make.leading.equalTo(expenseImage.snp.trailing).offset(5)
            make.centerY.equalTo(expenseImage.snp.centerY)
        }

        expenseView.addSubview(expenseLabel)
        expenseLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalTo(expenseImage.snp.leading).offset(2)
            make.top.equalTo(expenseImage.snp.bottom).offset(5)
        }
        
        view.addSubview(transactionsLabel)
        transactionsLabel.snp.makeConstraints { make in
            make.leading.equalTo(card.snp.leading)
            make.top.equalTo(card.snp.bottom).offset(30)
        }
        
        view.addSubview(seeAllButton)
        seeAllButton.snp.makeConstraints { make in
            make.trailing.equalTo(card.snp.trailing)
            make.centerY.equalTo(transactionsLabel.snp.centerY)
        }
        
        view.addSubview(backgroundViewOfTableView)
        backgroundViewOfTableView.snp.makeConstraints { make in
            make.top.equalTo(transactionsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.typeName, for: indexPath) as? TransactionTableViewCell {
            cell.configure(transactionData: presenter.dataForRowAt(indexPath.row))
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
}

extension HomeViewController: HomeViewProtocol {
    func setCardValues(total: String, expenses: String, incomes: String) {
        totalBalance.text = total
        expenseLabel.text = expenses
        incomeLabel.text = incomes
    }
    
    func reloadTransactionTableView() {
        transactionsTableView.reloadData()
    }
    
    func showLoader() {
        loaderView.showLoader()
    }
    
    func hideLoader() {
        loaderView.hideLoader()
    }
    
    func setUsername(username: String) {
        userNameLabel.text = username
    }
    
    func showFailure(with error: NetworkErrorModel) {
        AlertManager.showAlert(on: self, title: error.title , message: error.description)
    }
}
