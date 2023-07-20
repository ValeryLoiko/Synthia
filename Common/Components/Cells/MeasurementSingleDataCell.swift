//
//  MeasurementSingleDataCell.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 23/02/2023.
//

import UIKit
import SnapKit

class MeasurementSingleDataCell: UITableViewCell {
    static let identifier = "MeasurementSingleDataCell"

    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .clear
        return mainView
    }()
    
    private lazy var measurementResultLabel: UILabel = {
        let deviceNameLabel = UILabel()
        deviceNameLabel.backgroundColor = .clear
        deviceNameLabel.numberOfLines = 0
        deviceNameLabel.textColor = .blackColor
        deviceNameLabel.textAlignment = .left
        deviceNameLabel.font = UIFont.OpenSansSemiBold14
        return deviceNameLabel
    }()
    
    private lazy var measurementDateLabel: UILabel = {
        let deviceModelLabel = UILabel()
        deviceModelLabel.backgroundColor = .clear
        deviceModelLabel.numberOfLines = 0
        deviceModelLabel.textColor = UIColor.blackColor?.withAlphaComponent(0.4)
        deviceModelLabel.textAlignment = .right
        deviceModelLabel.font = UIFont.OpenSansRegular14
        return deviceModelLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(mainView)
        mainView.addSubview(measurementResultLabel)
        mainView.addSubview(measurementDateLabel)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(measurementResult: String, measurementData: String) {
        measurementResultLabel.text = measurementResult
        measurementDateLabel.text = measurementData
    }
    
    private func layoutViews() {
        mainView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        measurementDateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        measurementResultLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.height.equalTo(16)
            $0.right.equalTo(measurementDateLabel.snp.left).offset(-16)
        }
    }
}
