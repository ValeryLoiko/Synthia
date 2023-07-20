//
//  DiscoveredDeviceCell.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 23/12/2022.
//

import UIKit
import SnapKit

class DiscoveredPeripheralCell: UITableViewCell {
    static let identifier = "DiscoveredPeripheralCell"
    
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .white
        mainView.layer.borderColor = UIColor.blackColor?.cgColor
        mainView.layer.borderWidth = 1
        mainView.layer.cornerRadius = 8
        return mainView
    }()
    
    private lazy var deviceNameLabel: UILabel = {
        let deviceNameLabel = UILabel()
        deviceNameLabel.backgroundColor = .clear
        deviceNameLabel.numberOfLines = 0
        deviceNameLabel.textColor = .blackColor
        deviceNameLabel.textAlignment = .left
        deviceNameLabel.font = UIFont.OpenSansSemiBold14
        return deviceNameLabel
    }()
    
    private lazy var deviceModelLabel: UILabel = {
        let deviceModelLabel = UILabel()
        deviceModelLabel.backgroundColor = .clear
        deviceModelLabel.numberOfLines = 0
        deviceModelLabel.textColor = UIColor.blackColor?.withAlphaComponent(0.4)
        deviceModelLabel.textAlignment = .right
        deviceModelLabel.font = UIFont.OpenSansRegular14
        return deviceModelLabel
    }()
    
    private lazy var arrowImage: UIImageView = {
        let arrowImage = UIImageView()
        arrowImage.backgroundColor = .clear
        arrowImage.image = UIImage.assetImageName(AssetsCatalog.General.newDeviceArrow)
        arrowImage.tintColor = .black
        arrowImage.contentMode = .scaleToFill
        return arrowImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(mainView)
        mainView.addSubview(deviceNameLabel)
        mainView.addSubview(deviceModelLabel)
        mainView.addSubview(arrowImage)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(deviceName: String, deviceModel: String) {
        deviceNameLabel.text = deviceName
        deviceModelLabel.text = deviceModel
    }
    
    private func layoutViews() {
        mainView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.bottom.top.equalToSuperview()
        }

        deviceNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.height.equalTo(16)
            $0.width.equalTo(150)
        }
        
        arrowImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(6)
            $0.height.equalTo(12)
            $0.right.equalToSuperview().inset(25)
        }

        deviceModelLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(16)
            $0.left.equalTo(deviceNameLabel.snp.right)
            $0.right.equalTo(arrowImage.snp.left).offset(-17)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
}
