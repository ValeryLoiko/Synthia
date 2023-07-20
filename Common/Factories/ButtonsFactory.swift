//
//  Buttons.swift
//  Synthia
//
//  Created by Sławek on 11/01/2023.
//

import UIKit

enum ButtonStyle {
    case normal
    case transparent
    case transparentBorder
    case transparentBlackFontColor
    case image
    case rightXmarkBlack
    case rightStringBlack
    case rightStringPlus
    case leftDownload
    case leftBackButton
}

class Button: UIButton {
    var style: ButtonStyle = .normal {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    convenience init(style: ButtonStyle, title: String) {
        self.init()
        self.style = style
        self.setTitle(title, for: .normal)
        applyStyle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func enableButton() {
        self.isEnabled = true
    }
    
    func disableButton() {
        self.isEnabled = false
    }
    
    func showButton() {
        self.isHidden = false
        self.isEnabled = true
    }
    
    func hideButton() {
        self.isHidden = true
        self.isEnabled = false
    }
    
    static func continueWithGoogleButton() -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8.0
        button.clipsToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        
        let imageView = UIImageView(image: UIImage(named: SystemImages.LoginFlow.googleLogo))
        imageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = Localization.Buttons.googleLoginButton
        titleLabel.textAlignment = .center
        
        button.addSubview(imageView)
        button.addSubview(titleLabel)
        
        imageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(-34)
            $0.centerY.equalTo(button.snp.centerY)
            $0.width.equalTo(button.snp.width).multipliedBy(0.3)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(button.snp.centerY)
        }
        return button
    }
    
    static func measurementsHistoryButton() -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 8.0
        button.clipsToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        let label = UILabel()
        label.text = Localization.Buttons.measurementsHistoryButton
        label.font = UIFont.OpenSansSemiBold16
        label.textColor = UIColor.black
        button.addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(16)
        }
        let imageView = UIImageView()
        imageView.image = UIImage(named: AssetsCatalog.General.newDeviceArrow)
        imageView.tintColor = .black
        imageView.contentMode = .scaleToFill
        button.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-25)
        }
        return button
    }
    
    static func reminderButton() -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 8.0
        button.clipsToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        let label = UILabel()
        label.text = "Measurement reminder"
        label.font = UIFont.OpenSansSemiBold16
        label.textColor = UIColor.black
        button.addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(16)
        }
        let imageView = UIImageView()
        imageView.image = UIImage(named: AssetsCatalog.General.newDeviceArrow)
        imageView.tintColor = .black
        imageView.contentMode = .scaleToFill
        button.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-25)
        }
        let reminderLabel = UILabel()
        reminderLabel.text = "in 12 h"
        reminderLabel.font = UIFont.OpenSansRegular14
        reminderLabel.textColor = .black
        button.addSubview(reminderLabel)
        reminderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-48)
        }
        return button
    }
    
    static func settingsReusableButtonWithArrow(title: String) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 8.0
        button.clipsToBounds = true
        button.backgroundColor = .white
        let label = UILabel()
        label.text = title
        label.font = UIFont.OpenSansRegular14
        label.textColor = UIColor.black
        button.addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(16)
        }
        let imageView = UIImageView()
        imageView.image = UIImage(named: AssetsCatalog.General.newDeviceArrow)
        imageView.tintColor = .black
        imageView.contentMode = .scaleToFill
        button.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-25)
        }
        return button
    }
    
    static func settingsReusableWhiteButton(title: String) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 8.0
        button.clipsToBounds = true
        button.backgroundColor = .white
        let label = UILabel()
        label.text = title
        label.font = UIFont.OpenSansRegular14
        label.textColor = UIColor.black
        button.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return button
    }
    
    private func applyStyle() {
        switch style {
        case .normal:
            backgroundColor = .blackColor
            clipsToBounds = true
            layer.cornerRadius = 8
            let attributedTitle = NSAttributedString.createAttributedString(text: self.title(for: .normal), color: .whiteColor, font: .OpenSansRegular14)
            setAttributedTitle(attributedTitle, for: .normal)
        case .transparent:
            backgroundColor = .clear
            tintColor = UIColor.blackColor
            let attributedTitle = NSAttributedString.createAttributedString(text: self.title(for: .normal), color: .grayColor, font: .OpenSansRegular14)
            setAttributedTitle(attributedTitle, for: .normal)
        case .transparentBorder:
            backgroundColor = .clear
            clipsToBounds = true
            layer.cornerRadius = 8
            layer.borderWidth = 1
            layer.borderColor = UIColor.blackColor?.cgColor
            let attributedTitle = NSAttributedString.createAttributedString(text: self.title(for: .normal), color: .blackColor, font: .OpenSansRegular14)
            setAttributedTitle(attributedTitle, for: .normal)
        case .transparentBlackFontColor:
            backgroundColor = .clear
            tintColor = UIColor.blackColor
            let attributedTitle = NSAttributedString.createAttributedString(text: self.title(for: .normal), color: .blackColor, font: .OpenSansRegular14)
            setAttributedTitle(attributedTitle, for: .normal)
        case .image:
            break
        case .rightXmarkBlack:
            setTitleColor(.blackColor, for: .normal)
            setImage(UIImage(systemName: SystemImages.General.closeImage), for: .normal)
            semanticContentAttribute = .forceRightToLeft
        case .rightStringBlack:
            let attributedTitle = NSAttributedString.createAttributedString(text: self.title(for: .normal), color: .blackColor, font: .OpenSansSemiBold16)
            setAttributedTitle(attributedTitle, for: .normal)
        case .rightStringPlus:
            setTitleColor(.blackColor, for: .normal)
            setImage(UIImage.assetImageName(AssetsCatalog.General.plusIcon), for: .normal)
            semanticContentAttribute = .forceRightToLeft
        case .leftDownload:
            setTitleColor(.blackColor, for: .normal)
            setImage(UIImage.assetImageName(AssetsCatalog.Measurements.downloadSign), for: .normal)
            semanticContentAttribute = .forceLeftToRight
        case .leftBackButton:
            setTitleColor(.blackColor, for: .normal)
            setImage(UIImage(systemName: SystemImages.General.leftArrow), for: .normal)
            semanticContentAttribute = .forceLeftToRight
        }
    }
}
