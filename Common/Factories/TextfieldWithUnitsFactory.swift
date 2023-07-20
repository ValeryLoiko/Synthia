//
//  TextfieldWithUnits.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 23/01/2023.
//

import UIKit

enum UnitTextFieldType {
    case numericKeyboard
    case floatingNumericKeyboard
}

final class UnitsTextField: UIView {
    typealias L = Localization
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.OpenSansRegular14
        label.textColor = UIColor.grayColor
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.OpenSansRegular14
        label.textColor = UIColor.blackColor
        label.textAlignment = .right
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.blackColor
        textField.font = UIFont.OpenSansRegular14
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.batteryTextColor?.cgColor
        textField.setLeftPaddingPoints(12)
        return textField
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.OpenSansRegular12
        label.textColor = .red
        label.backgroundColor = .clear
        return label
    }()
    
    convenience init(type: UnitTextFieldType, title: String, placeholder: String, unit: String) {
        self.init()
        layoutView(type: type, title: title, placeholder: placeholder, unit: unit)
    }
    
    private func layoutView(type: UnitTextFieldType, title: String, placeholder: String, unit: String) {
        addSubview(stackView)
        switch type {
        case .numericKeyboard:
            titleLabel.text = title
            unitLabel.text = unit
            textField.placeholder = placeholder
            textField.keyboardType = .numberPad
            textField.returnKeyType = .done
        case .floatingNumericKeyboard:
            titleLabel.text = title
            unitLabel.text = unit
            textField.placeholder = placeholder
            textField.keyboardType = .decimalPad
            textField.returnKeyType = .done
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.left.right.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(16)
        }
        
        addSubview(unitLabel)
        unitLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.top).inset(20)
            $0.height.equalTo(16)
            $0.width.equalTo(171)
            $0.right.equalToSuperview().inset(16)
        }
    }
}
