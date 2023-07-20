//
//  SavedDevicesCell.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 12/01/2023.
//

import UIKit
import SnapKit

class SavedDevicesCell: UICollectionViewCell {
    typealias A = AssetsCatalog.AddDevice
    static let identifier = "SavedDevicesCollectionViewCell"
    
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.layer.cornerRadius = 8
        return mainView
    }()
    
    private lazy var deviceImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage.assetImageName(A.deviceImage)
        image.tintColor = .blackColor
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var deviceNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = UIColor.blackColor
        label.textAlignment = .left
        label.font = UIFont.OpenSansSemiBold16
        return label
    }()
    
    private lazy var connectionStatusLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = UIColor.blackColor
        label.textAlignment = .left
        label.font = UIFont.OpenSansRegular14
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.addSubview(deviceImage)
        mainView.addSubview(deviceNameLabel)
        mainView.addSubview(connectionStatusLabel)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(deviceName: String, connectionStatus: String) {
        deviceNameLabel.text = deviceName
        connectionStatusLabel.text = connectionStatus
    }
    
    private func layoutViews() {
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deviceImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(140)
            $0.top.left.right.equalToSuperview().inset(16)
        }
        
        deviceNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(32)
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(deviceImage.snp.bottom).offset(12)
        }
        
        connectionStatusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(deviceNameLabel.snp.bottom)
        }
    }
}
