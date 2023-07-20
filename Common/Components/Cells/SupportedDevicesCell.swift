//
//  SupportedDevicesCell.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 13/03/2023.
//

import UIKit
import SnapKit

class SupportedDevicesCell: UITableViewCell {
    typealias M = AssetsCatalog.Measurements
    static let identifier = "SupportedDevicesCell"

    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .clear
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
    
    private lazy var producerNameLabel: UILabel = {
        let producerNameLabel = UILabel()
        producerNameLabel.backgroundColor = .clear
        producerNameLabel.numberOfLines = 0
        producerNameLabel.textColor = UIColor.blackColor?.withAlphaComponent(0.4)
        producerNameLabel.textAlignment = .left
        producerNameLabel.font = UIFont.OpenSansRegular14
        return producerNameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(mainView)
        mainView.addSubview(deviceNameLabel)
        mainView.addSubview(producerNameLabel)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(deviceName: String, producerName: String) {
        deviceNameLabel.text = deviceName
        producerNameLabel.text = producerName
    }
    
    private func layoutViews() {
        mainView.snp.makeConstraints {
            $0.bottom.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }

        deviceNameLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
            $0.height.equalTo(22)
        }

        producerNameLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(deviceNameLabel.snp.bottom).offset(8)
            $0.height.equalTo(16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
}
