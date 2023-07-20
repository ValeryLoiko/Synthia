//
//  TextDieldWithImageFactory.swift
//  Synthia
//
//  Created by Sławek on 06/02/2023.
//

import UIKit

enum ImageTexFiledType {
    case picker
}

final class ImagesTextField: UIView {
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
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .blackColor
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.blackColor
        textField.font = UIFont.OpenSansRegular14
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.batteryTextColor?.cgColor
        textField.tintColor = .clear
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
    
    convenience init(type: ImageTexFiledType, title: String, placeholder: String, image: UIImage?) {
        self.init()
        layoutView(type: type, title: title, placeholder: placeholder, image: image)
    }
    
    private func layoutView(type: ImageTexFiledType, title: String, placeholder: String, image: UIImage?) {
        addSubview(stackView)
        switch type {
        case .picker:
            titleLabel.text = title
            imageView.image = image
            textField.placeholder = placeholder
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
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.top).inset(20)
            make.height.equalTo(16)
            make.width.equalTo(16)
            make.right.equalToSuperview().inset(16)
        }
    }
}
