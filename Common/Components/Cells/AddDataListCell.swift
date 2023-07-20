//
//  AddDataListCell.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 24/02/2023.
//

import UIKit
import SnapKit

class AddDataListCell: UITableViewCell {
    static let identifier = "AddDataListCell"

    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .clear
        return mainView
    }()
    
    private lazy var dataTypeLabel: UILabel = {
        let deviceNameLabel = UILabel()
        deviceNameLabel.backgroundColor = .clear
        deviceNameLabel.numberOfLines = 0
        deviceNameLabel.textColor = .blackColor
        deviceNameLabel.textAlignment = .left
        deviceNameLabel.font = UIFont.OpenSansSemiBold14
        return deviceNameLabel
    }()
    
    private lazy var arrowImage: UIImageView = {
        let arrowImage = UIImageView()
        arrowImage.image = UIImage.assetImageName(AssetsCatalog.General.newDeviceArrow)
        arrowImage.tintColor = .black
        arrowImage.contentMode = .scaleToFill
        return arrowImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(mainView)
        mainView.addSubview(dataTypeLabel)
        mainView.addSubview(arrowImage)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(dataType: String) {
        dataTypeLabel.text = dataType
    }
    
    private func layoutViews() {
        mainView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        arrowImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(4)
            $0.height.equalTo(8)
            $0.right.equalToSuperview().inset(22)
        }
        
        dataTypeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.height.equalTo(16)
            $0.right.equalTo(arrowImage.snp.left).offset(-16)
        }
    }
}
