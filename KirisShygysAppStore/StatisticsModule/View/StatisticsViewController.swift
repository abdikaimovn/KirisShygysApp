//
//  StatisticsViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 26.02.2024.
//

import UIKit
import DGCharts
import SnapKit

final class StatisticsViewController: UIViewController {
    private let presenter: StatisticsPresenter
    
    //MARK: - UI Elements
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "thisMonthTitle_label".localized.uppercased()
        label.font = .font(style: .title, withSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let transactionTypeSegmentedControl: UISegmentedControl = {
        let sControl = UISegmentedControl()
        sControl.insertSegment(withTitle: "incomes_label".localized, at: 0, animated: true)
        sControl.insertSegment(withTitle: "expenses_label".localized, at: 1, animated: true)
        sControl.selectedSegmentTintColor = .incomeColor
        sControl.selectedSegmentIndex = 0
        return sControl
    }()
    
    private let chart: BarChartView = {
        let chart = BarChartView()
        chart.backgroundColor = .white
        chart.layer.cornerRadius = 20
        chart.layer.cornerCurve = .continuous
        chart.isUserInteractionEnabled = false
        chart.legend.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.animate(yAxisDuration: 1.0)
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        chart.xAxis.labelFont = .font(style: .body, withSize: 10)
        return chart
    }()
    
    private let chartsScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = true
        return scroll
    }()
    
    private let absenceDataView: AbsenceDataView = {
        let absenseDataView = AbsenceDataView()
        return absenseDataView
    }()
    
    private let moneyFlowTableView = UITableView()
    
    //MARK: - Lifecycle
    init(presenter: StatisticsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.viewDidLoaded(transactionTypeSegmentedControl.selectedSegmentIndex)
    }
    
    //MARK: - Functions
    private func setupMoneyFlowTableView() {
        moneyFlowTableView.dataSource = self
        moneyFlowTableView.backgroundColor = .clear
        moneyFlowTableView.register(MoneyFlowTableViewCell.self, forCellReuseIdentifier: MoneyFlowTableViewCell.typeName)
        moneyFlowTableView.separatorStyle = .none
        moneyFlowTableView.isUserInteractionEnabled = false
    }
    private func setupNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .white
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    private func createBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4
        return view
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }
    
    private func setupSegmentedControlTarget() {
        transactionTypeSegmentedControl.addTarget(self, action: #selector(segmentedControlDidChanged), for: .valueChanged)
    }
    
    @objc func segmentedControlDidChanged() {
        presenter.segmentedControlDidChanged(transactionTypeSegmentedControl.selectedSegmentIndex)
    }
    
    private func setupView() {
        view.backgroundColor = .incomeColor

        view.addSubview(monthLabel)
        monthLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        let stackView = createStackView()
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        let controlsBackView = createBackgroundView()
        let chartBackView = createBackgroundView()
        let moneyInfoBackView = createBackgroundView()
        
        stackView.addArrangedSubview(controlsBackView)
        stackView.addArrangedSubview(chartBackView)
        stackView.addArrangedSubview(moneyInfoBackView)
        
        controlsBackView.addSubview(transactionTypeSegmentedControl)
        transactionTypeSegmentedControl.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        setupSegmentedControlTarget()
        
        chartBackView.addSubview(chartsScrollView)
        chartsScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.height.equalTo(view.snp.height).dividedBy(2.5)
        }
        
        chartsScrollView.addSubview(chart)
        chart.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(chartBackView.snp.width).multipliedBy(2)
            make.height.equalToSuperview()
        }
        
        chartBackView.addSubview(absenceDataView)
        absenceDataView.layer.cornerRadius = chartBackView.layer.cornerRadius
        absenceDataView.layer.cornerCurve = chartBackView.layer.cornerCurve
        absenceDataView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        moneyInfoBackView.addSubview(moneyFlowTableView)
        moneyFlowTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.height.equalTo(110)
        }
        setupMoneyFlowTableView()
    }
}

extension StatisticsViewController: StatisticsViewProtocol {
    func setupChart(with model: ChartModel) {
        chart.data = BarChartData(dataSet: model.chartData)
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: model.xAxisTitles)
        chart.xAxis.labelCount = model.xAxisTitles.count
        chart.animate(yAxisDuration: 0.5)
    }
    
    func updateView(with color: UIColor) {
        absenceDataView.hideView()
        transactionTypeSegmentedControl.selectedSegmentTintColor = color
        view.backgroundColor = color
    }
    
    func showAbsenceDataView(withColor color: UIColor) {
        absenceDataView.showView(withColor: color)
        transactionTypeSegmentedControl.selectedSegmentTintColor = color
        view.backgroundColor = color
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInFlowModel()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MoneyFlowTableViewCell.typeName, for: indexPath) as? MoneyFlowTableViewCell {
            cell.configure(with: presenter.dataForRowAt(indexPath.row))
            return cell
        }
        
        return UITableViewCell()
    }
}
