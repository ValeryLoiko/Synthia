//
//  ToastMessageFactory.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 26/01/2023.
//

import UIKit

enum ToastMessageStyle {
    case oneLabel
    case twoLabels
}

class ToastMessage: UIView {
    private lazy var contentView: UIView = {
       let view = UIView()
        view.backgroundColor = .blackColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var toastIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.tintColor = .whiteColor
        image.backgroundColor = .clear
        return image
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.sfProTextBold17
        return label
    }()
    
    private lazy var additionalLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.sfProTextBold17
        return label
    }()
    
    convenience init(style: ToastMessageStyle, imageName: String, mainLabelText: String, additionalLabelText: String) {
        self.init()
        layoutView(style: style, imageName: imageName, mainLabelText: mainLabelText, additionalLabelText: additionalLabelText)
    }

    private func layoutView(style: ToastMessageStyle, imageName: String, mainLabelText: String, additionalLabelText: String) {
        toastIcon.image = UIImage.assetImageName(imageName)
        mainLabel.text = mainLabelText
        additionalLabel.text = additionalLabelText
        addSubview(contentView)
        addSubview(toastIcon)
        addSubview(mainLabel)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        toastIcon.snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(24)
            $0.width.height.equalTo(24)
        }
        
        mainLabel.snp.makeConstraints {
            $0.left.equalTo(toastIcon.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(26)
        }
        
        switch style {
        case .oneLabel:
            mainLabel.textAlignment = .left
        case .twoLabels:
            mainLabel.textAlignment = .center
            addSubview(additionalLabel)
            additionalLabel.text = additionalLabelText
            additionalLabel.textAlignment = .center
            
            additionalLabel.snp.makeConstraints {
                $0.right.equalToSuperview().inset(24)
                $0.top.equalToSuperview().inset(24)
                $0.bottom.equalToSuperview().inset(26)
                $0.width.equalTo(74)
            }
            
            mainLabel.snp.remakeConstraints {
                $0.left.equalTo(toastIcon.snp.right).offset(16)
                $0.top.equalToSuperview().inset(24)
                $0.bottom.equalToSuperview().inset(26)
                $0.right.equalTo(additionalLabel.snp.left).offset(-16)
            }
        }
    }
}
