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
    
    //MARK: - UI Elements
    private let loaderView = LoaderView(with: .medium)
    
    private let filterTransactionLabel: UILabel = {
        let label = UILabel()
        label.text = "filterTransactions_label".localized
        label.font = .font(style: .body)
        label.textColor = .black
        return label
    }()
    
    private let filterButton = ExtendedTapAreaButton()
    
    private let transactionsTableView = UITableView()
    
    private let absenceDataView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    private let absenceDataImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "xmark.bin.fill")
        view.tintColor = .grayColor
        return view
    }()
    
    private let absenceDataLabel: UILabel = {
        let label = UILabel()
        label.font = .font(style: .body, withSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.alpha = 0.6
        label.numberOfLines = 0
        label.text = "absenceData_label".localized
        return label
    }()
    
    private let backgroundTransactionInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.isHidden = true
        return view
    }()
    
    private let detailedTransactionInfoView: DetailedTransactionInfoView = {
        let view = DetailedTransactionInfoView()
        view.isHidden = true
        return view
    }()
    
    private let closeTransactionInfoButton: UIButton = {
        let button = ExtendedTapAreaButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.isHidden = true
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    //MARK: - Lifecycle
    init(presenter: HistoryPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
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
        
        presenter.viewDidLoaded()
    }
    
    //MARK: - Functions
    private func setupAbsenceDataView() {
        absenceDataView.addSubview(absenceDataImageView)
        absenceDataImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalToSuperview().dividedBy(1.5)
        }
        
        absenceDataView.addSubview(absenceDataLabel)
        absenceDataLabel.snp.makeConstraints { make in
            make.top.equalTo(absenceDataImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
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
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.contentHorizontalAlignment = .fill
        filterButton.contentVerticalAlignment = .fill
        filterButton.backgroundColor = .clear
        filterButton.layer.cornerRadius = 10
        filterButton.layer.cornerCurve = .continuous
        filterButton.tintColor = .brownColor
        filterButton.addTarget(self, action: #selector(showFilters), for: .touchUpInside)
    }
    
    @objc private func showFilters() {
        let transactionFilterVC = FilterViewController(delegate: self)
        if let sheet = transactionFilterVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.present(transactionFilterVC, animated: true, completion: nil)
    }
    
    @objc private func closeTranscationInfoTapped() {
        presenter.closeTransactionInfoTapped()
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
            make.size.equalTo(30)
            make.leading.greaterThanOrEqualTo(filterTransactionLabel.snp.trailing).offset(20)
        }
        
        view.addSubview(transactionsTableView)
        transactionsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.top.equalTo(filterButton.snp.bottom).offset(10)
        }
        
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(absenceDataView)
        absenceDataView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(view.snp.width).dividedBy(2.5)
        }
        
        setupAbsenceDataView()
        
        view.addSubview(backgroundTransactionInfoView)
        backgroundTransactionInfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(closeTransactionInfoButton)
        closeTransactionInfoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(30)
            make.size.equalTo(20)
        }
        
        closeTransactionInfoButton.addTarget(self, action: #selector(closeTranscationInfoTapped), for: .touchUpInside)
        
        view.addSubview(detailedTransactionInfoView)
        detailedTransactionInfoView.snp.makeConstraints { make in
            make.top.equalTo(closeTransactionInfoButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().dividedBy(2)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.titleForHeaderInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.typeName, for: indexPath) as? HistoryTableViewCell {
            
            cell.configure(transactionData: presenter.dataForRowAt(indexPath))
            
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.cellIsDeletingForRow(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
}

extension HistoryViewController: HistoryViewProtocol {
    func hideDetailedTransactionInfo() {
        detailedTransactionInfoView.isHidden = true
        closeTransactionInfoButton.isHidden = true
        backgroundTransactionInfoView.isHidden = true
        
        navigationController?.navigationBar.topItem?.hidesBackButton = false
    }
    
    func showDetailedTransactionInfo(with data: ValidatedTransactionModel) {
        backgroundTransactionInfoView.alpha = 0.9
        detailedTransactionInfoView.configure(transactionModel: data)
        
        detailedTransactionInfoView.isHidden = false
        closeTransactionInfoButton.isHidden = false
        backgroundTransactionInfoView.isHidden = false
        
        navigationController?.navigationBar.topItem?.hidesBackButton = true
    }
    
    func showFailure(with errorModel: NetworkErrorModel) {
        AlertManager.showAlert(on: self, title: errorModel.title, message: errorModel.description)
    }
    
    func reloadTransactionsTableView() {
        transactionsTableView.reloadData()
    }
    
    func showLoader() {
        loaderView.showLoader()
    }
    
    func hideLoader() {
        loaderView.hideLoader()
    }
    
    func showAbsenceDataView() {
        absenceDataView.isHidden = false
    }
    
    func hideAbsenceDataView() {
        absenceDataView.isHidden = true
    }
}

extension HistoryViewController: FilterViewDelegate {
    func didGetFilterSettings(filterData: FilterModel) {
        presenter.didGetFilterSettings(filterModel: filterData)
    }
}
