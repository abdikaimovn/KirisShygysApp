//
//  FilterViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 19.02.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didGetFilterSettings(filterData: FilterModel)
}

final class FilterViewController: UIViewController {
    weak var delegate: FilterViewControllerDelegate?
    private var filterModel = FilterModel(filterBy: nil, sortBy: nil, period: nil)
    
    //MARK: - UI Elements
    private let filterByExpenseButton = UIButton()

    private let filterByIncomeButton = UIButton()
    
    private let sortByNewestButton = UIButton()
    
    private let sortByOldestButton = UIButton()
    
    private let weekPeriodButton = UIButton()
    
    private let monthPeriodButton = UIButton()
    
    private let halfYearPeriodButton = UIButton()
    
    private let yearPeriodButton = UIButton()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("reset_button_title".localized, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .font(style: .button)
        button.layer.cornerCurve = .continuous
        button.backgroundColor = .expenseColor
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return button
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setTitle("apply_button_title".localized, for: .normal)
        button.layer.cornerCurve = .continuous
        button.layer.borderColor = UIColor.brownColor.cgColor
        button.layer.borderWidth = 1
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .brownColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(style: .button)
        return button
    }()

    private let closeLine: UIView = {
        let view = UIView()
        view.backgroundColor = .brownColor
        return view
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    //MARK: - Lifecycle
    init(delegate: FilterViewControllerDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupButtons()
        activateButtons()
    }
    
    deinit {
        print("Filter vc deinited")
    }
    
    //MARK: - Functions
    private func setupButtons() {
        configureButton(filterByExpenseButton, "expenses_label".localized)
        configureButton(filterByIncomeButton, "incomes_label".localized)
        configureButton(sortByNewestButton, "newest_button_title".localized)
        configureButton(sortByOldestButton, "oldest_button_title".localized)
        configureButton(weekPeriodButton, "week_button_title".localized)
        configureButton(monthPeriodButton, "month_button_title".localized)
        configureButton(halfYearPeriodButton, "halfYear_button_title".localized)
        configureButton(yearPeriodButton, "year_button_title".localized)
    }
    
    private func configureButton(_ button: UIButton, _ title: String) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerCurve = .continuous
        button.layer.borderColor = UIColor.brownColor.cgColor
        button.layer.borderWidth = 1
        button.contentHorizontalAlignment = .center
    }
    
    private func activateButtons() {
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        filterByIncomeButton.addTarget(self, action: #selector(incomeButtonTapped), for: .touchUpInside)
        filterByExpenseButton.addTarget(self, action: #selector(expenseButtonTapped), for: .touchUpInside)

        sortByNewestButton.addTarget(self, action: #selector(sortByNewestButtonTapped), for: .touchUpInside)
        sortByOldestButton.addTarget(self, action: #selector(sortByOldestButtonTapped), for: .touchUpInside)
        
        weekPeriodButton.addTarget(self, action: #selector(weekPeriodButtonTapped), for: .touchUpInside)
        monthPeriodButton.addTarget(self, action: #selector(monthPeriodButtonTapped), for: .touchUpInside)
        halfYearPeriodButton.addTarget(self, action: #selector(halfyearPeriodButtonTapped), for: .touchUpInside)
        yearPeriodButton.addTarget(self, action: #selector(yearPeriodButtonTapped), for: .touchUpInside)
        
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func applyButtonTapped() {
        delegate?.didGetFilterSettings(filterData: filterModel)
        dismiss(animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(closeLine)
        closeLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.height.equalTo(3)
            make.width.equalTo(30)
        }
        
        let filterTransactionLabel = generateTitleLabel("filterTransactions_label".localized)
        //Filter titles
        let filterByLabel = generateTitleLabel("filterBy_label".localized)
        let sortByLabel = generateTitleLabel("sortBy_label".localized)
        let periodLabel = generateTitleLabel("period_label".localized)
        
        //Filter horizontal stack those will contain buttons to identify
        let filterByStack = generateStackView()
        let sortByStack = generateStackView()
        let periodStack = generateStackView()
        
        view.addSubview(filterTransactionLabel)
        filterTransactionLabel.setContentHuggingPriority(.required, for: .vertical)
        filterTransactionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(closeLine.snp.bottom).offset(10)
        }
        
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.leading.greaterThanOrEqualTo(filterTransactionLabel.snp.trailing).offset(20)
            make.centerY.equalTo(filterTransactionLabel.snp.centerY)
        }
        
        view.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(resetButton.snp.bottom).offset(20)
        }
        
        verticalStack.addArrangedSubview(filterByLabel)
        verticalStack.addArrangedSubview(filterByStack)
        filterByStack.addArrangedSubview(filterByExpenseButton)
        filterByStack.addArrangedSubview(filterByIncomeButton)
        
        
        verticalStack.addArrangedSubview(sortByLabel)
        verticalStack.addArrangedSubview(sortByStack)
        sortByStack.addArrangedSubview(sortByNewestButton)
        sortByStack.addArrangedSubview(sortByOldestButton)
        
        verticalStack.addArrangedSubview(periodLabel)
        verticalStack.addArrangedSubview(periodStack)
        periodStack.addArrangedSubview(weekPeriodButton)
        periodStack.addArrangedSubview(monthPeriodButton)
        periodStack.addArrangedSubview(halfYearPeriodButton)
        periodStack.addArrangedSubview(yearPeriodButton)
        
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(verticalStack.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }

    private func generateTitleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .font(style: .label)
        label.textColor = .black
        return label
    }
    
    private func generateStackView() -> UIStackView {
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        return stack
    }
}

//MARK: - Functionality of buttons in stackViews
extension FilterViewController {
    private func updateButtons(_ selectedButton: UIButton, _ buttons: [UIButton]) {
        UIView.animate(withDuration: 0.2) {
            selectedButton.backgroundColor = .brownColor
            selectedButton.setTitleColor(.white, for: .normal)

            for button in buttons {
                if button != selectedButton {
                    button.backgroundColor = .clear
                    button.setTitleColor(.black, for: .normal)
                }
            }
        }
    }
    
    @objc private func resetButtonTapped() {
        updateButtons(resetButton, [filterByExpenseButton, filterByIncomeButton,
                                    sortByNewestButton, sortByOldestButton,
                                    monthPeriodButton, halfYearPeriodButton, yearPeriodButton, weekPeriodButton])
        resetButton.backgroundColor = .expenseColor
        resetButton.setTitleColor(.white, for: .normal)
        filterModel = FilterModel(filterBy: nil, sortBy: nil, period: nil)
        applyButtonTapped()
    }
    
    @objc private func expenseButtonTapped() {
        updateButtons(filterByExpenseButton, [filterByIncomeButton])
        filterModel.filterBy = .expense
    }
    
    @objc private func incomeButtonTapped() {
        updateButtons(filterByIncomeButton, [filterByExpenseButton])
        filterModel.filterBy = .income
    }
    
    @objc private func sortByNewestButtonTapped() {
        updateButtons(sortByNewestButton, [sortByOldestButton])
        filterModel.sortBy = .newest
    }
    
    @objc private func sortByOldestButtonTapped() {
        updateButtons(sortByOldestButton, [sortByNewestButton])
        filterModel.sortBy = .oldest
    }
    
    @objc private func weekPeriodButtonTapped() {
        updateButtons(weekPeriodButton, [monthPeriodButton, halfYearPeriodButton, yearPeriodButton])
        filterModel.period = .week
    }
    
    @objc private func monthPeriodButtonTapped() {
        updateButtons(monthPeriodButton, [weekPeriodButton, halfYearPeriodButton, yearPeriodButton])
        filterModel.period = .month
    }
    
    @objc private func halfyearPeriodButtonTapped() {
        updateButtons(halfYearPeriodButton, [monthPeriodButton, weekPeriodButton, yearPeriodButton])
        filterModel.period = .halfyear
    }
    
    @objc private func yearPeriodButtonTapped() {
        updateButtons(yearPeriodButton, [monthPeriodButton, halfYearPeriodButton, weekPeriodButton])
        filterModel.period = .year
    }
}
