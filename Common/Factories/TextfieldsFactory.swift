//
//  UITextField+UILabel+Ext.swift
//  Synthia
//
//  Created by Walery Łojko on 10/01/2023.
//

import UIKit

enum TextFieldType {
    case generalField
    case passwordField
    case numberField
    case floatNumberField
}

final class TextFieldInput: UIView {
    typealias L = Localization
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelText, textField, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var labelText: UILabel = {
        let label = UILabel()
        label.font = UIFont.OpenSansRegular14
        label.textColor = UIColor.grayColor
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
    
    func getText() -> String {
        textField.text ?? ""
    }
    
    convenience init(type: TextFieldType, title: String, placeholder: String) {
        self.init()
        layoutView(type: type, title: title, placeholder: placeholder)
    }
    
    private func layoutView(type: TextFieldType, title: String, placeholder: String) {
        addSubview(stackView)
        
        switch type {
        case .generalField:
            labelText.text = title
            textField.placeholder = placeholder
            textField.textContentType = .emailAddress
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .next
            textField.isSecureTextEntry = false
        case .passwordField:
            labelText.text = title
            textField.placeholder = placeholder
            textField.isSecureTextEntry = true
            textField.textContentType = .password
            textField.returnKeyType = .done
            textField.keyboardType = .default
        case .numberField:
            labelText.text = title
            textField.placeholder = placeholder
            textField.keyboardType = .numberPad
            textField.returnKeyType = .done
            textField.textContentType = .oneTimeCode
        case .floatNumberField:
            labelText.text = title
            textField.placeholder = placeholder
            textField.keyboardType = .decimalPad
            textField.returnKeyType = .done
            textField.textContentType = .oneTimeCode
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelText.snp.makeConstraints {
            $0.height.equalTo(16)
        }
        
        textField.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.left.right.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(16)
        }
    }
}
