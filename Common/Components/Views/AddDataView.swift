//
//  AddDataView.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 24/02/2023.
//

import UIKit
import SnapKit

class AddDataView: UIView {
    private lazy var mainView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [dateView, timeView, resultView])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var dateView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = .OpenSansSemiBold14
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone(abbreviation: "CET")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .black
        datePicker.backgroundColor = .clear
        return datePicker
    }()
    
    private lazy var dateSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var timeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = .OpenSansSemiBold14
        return label
    }()
    
    lazy var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.locale = Locale(identifier: "en_GB")
        timePicker.timeZone = TimeZone(abbreviation: "CET")
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .compact
        timePicker.tintColor = .black
        timePicker.backgroundColor = .clear
        return timePicker
    }()
    
    private lazy var timeSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var resultView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.font = .OpenSansSemiBold14
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.blackColor
        textField.font = UIFont.OpenSansRegular14
        textField.backgroundColor = .clear
        textField.textAlignment = .right
        textField.setRightPaddingPoints(16)
        textField.keyboardType = .decimalPad
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.OpenSansRegular14
        label.textAlignment = .center
        label.textColor = .darkGray
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureResultView(measurementName: String) {
        resultLabel.text = "Unit of \(measurementName)"
    }
    
    private func setupView() {
        addSubview(contentView)
        contentView.addSubview(mainView)
        contentView.addSubview(errorLabel)
        dateView.addSubview(dateLabel)
        dateView.addSubview(datePicker)
        dateView.addSubview(dateSeparatorView)
        timeView.addSubview(timeLabel)
        timeView.addSubview(timePicker)
        timeView.addSubview(timeSeparatorView)
        resultView.addSubview(resultLabel)
        resultView.addSubview(textField)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(16)
        }
        mainView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(dateLabel.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        dateSeparatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        timePicker.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(timeLabel.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        timeSeparatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.width.equalToSuperview().dividedBy(2).inset(16)
        }
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview()
            $0.left.equalTo(resultLabel.snp.right).offset(16)
        }
    }
}
