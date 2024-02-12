//
//  TransactionViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 12.02.2024.
//

import UIKit
import SnapKit

final class TransactionViewController: UIViewController {
    
    private let surfaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let sControl = UISegmentedControl()
        sControl.insertSegment(withTitle: "incomes_label".localized, at: 0, animated: true)
        sControl.insertSegment(withTitle: "expenses_label".localized, at: 1, animated: true)
        sControl.selectedSegmentIndex = 0
        sControl.selectedSegmentTintColor = .incomeColor
        return sControl
    }()
    
    private let transNameLabel: UILabel = {
        let label = UILabel()
        label.text = "name_label".localized
        label.textColor = .black
        label.font = .font(style: .label)
        return label
    }()
    
    private let transNameTextField: UITextField = {
        let field = UITextField()
        field.font = .font(style: .label)
        field.backgroundColor = .lightGrayColor
        field.layer.cornerRadius = 10
        field.layer.cornerCurve = .continuous
        field.textColor = .black
        field.returnKeyType = .done
        return field
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "description_label".localized
        label.textColor = .black
        label.font = .font(style: .label)
        return label
    }()
    
    private let descriptionTextField: UITextView = {
        let description = UITextView()
        description.backgroundColor = .lightGrayColor
        description.textColor = .black
        description.layer.cornerRadius = 10
        description.layer.cornerCurve = .continuous
        description.font = .font(style: .label)
        description.returnKeyType = .done
        return description
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "amount_label".localized
        label.textColor = .white
        label.font = .font(style: .title, withSize: 25)
        return label
    }()
    
    private let amountTextField: UITextField = {
        let field = UITextField()
        field.font = .font(style: .mediumLabel, withSize: 40)
        field.backgroundColor = .clear
        field.placeholder = "0"
        field.textColor = .white
        field.layer.cornerRadius = 16
        field.keyboardType = .numberPad
        field.returnKeyType = .default
        return field
    }()
    
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.text = "date_label".localized
        label.textColor = .black
        label.font = .font(style: .label)
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.font = .font(style: .button)
        label.textColor = .white
        button.titleLabel?.font = label.font
        button.setTitle("save_button_title".localized, for: .normal)
        button.backgroundColor = .incomeColor
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.4
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let calendar = UIDatePicker()
        calendar.locale = .current
        calendar.datePickerMode = .dateAndTime
        calendar.timeZone = .current
        calendar.backgroundColor = .white
        calendar.preferredDatePickerStyle = .automatic
        calendar.tintColor = .incomeColor
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTextFieldDelegates()
    }

    private func setupTextFieldDelegates() {
        transNameTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    private func setupView() {
        view.backgroundColor = .incomeColor
        
        view.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
        }
        
        view.addSubview(amountTextField)
        amountTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalTo(amountLabel.snp.bottom).offset(15)
        }
        
        //Left view mode of the amount text field
        let leftView = UIView()
        leftView.backgroundColor = .clear
        let dollarLabel = UILabel()
        dollarLabel.text = "\("currency".localized) "
        dollarLabel.font = amountTextField.font
        dollarLabel.textColor = .white
        leftView.addSubview(dollarLabel)
        dollarLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        amountTextField.leftView = leftView
        amountTextField.leftViewMode = .always
        
        view.addSubview(surfaceView)
        surfaceView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
        }
        
        surfaceView.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        surfaceView.addSubview(transNameLabel)
        transNameLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        surfaceView.addSubview(transNameTextField)
        transNameTextField.snp.makeConstraints { make in
            make.top.equalTo(transNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(segmentedControl.snp.leading)
            make.trailing.equalTo(segmentedControl.snp.trailing)
            make.height.equalTo(40)
        }
        
        let transNameLeftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: transNameTextField.bounds.height)))
        transNameTextField.leftView = transNameLeftView
        transNameTextField.leftViewMode = .always
        
        surfaceView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(transNameTextField.snp.bottom).offset(15)
        }
        
        surfaceView.addSubview(descriptionTextField)
        descriptionTextField.snp.makeConstraints { make in
            make.leading.equalTo(segmentedControl.snp.leading)
            make.trailing.equalTo(segmentedControl.snp.trailing)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.height.equalTo(150)
        }
        
        surfaceView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(15)
            make.trailing.equalTo(segmentedControl.snp.trailing)
        }
        
        surfaceView.addSubview(calendarLabel)
        calendarLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.trailing.greaterThanOrEqualTo(datePicker.snp.leading).inset(10)
            make.centerY.equalTo(datePicker.snp.centerY)
        }
        
        surfaceView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
            make.bottom.equalTo(surfaceView.snp.bottom).offset(-20)
        }
    }
}

extension TransactionViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when return is tapped
        textField.resignFirstResponder()
        return true
    }
}
