//
//  LatestMeasurementsCell.swift
//  Synthia
//
//  Created by Walery Łojko on 06/02/2023.
//

import SnapKit
import UIKit

class LatestMeasurementsCell: UITableViewCell {
    static let identifier = "LatestMeasurementsCell"

    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var characteristicLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.OpenSansRegular14
        label.textColor = UIColor.blackColor?.withAlphaComponent(0.4)
        return label
    }()
    
    private lazy var charDataLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.OpenSansRegular14
        label.textColor = .blackColor
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.OpenSansRegular14
        label.textColor = UIColor.blackColor?.withAlphaComponent(0.4)
        return label
    }()
    
    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AssetsCatalog.General.newDeviceArrow)
        imageView.tintColor = .black
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(mainView)
        mainView.addSubview(characteristicLabel)
        mainView.addSubview(charDataLabel)
        mainView.addSubview(dateLabel)
        mainView.addSubview(arrowImage)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(characteristic: String, charData: String, date: String) {
        characteristicLabel.text = characteristic
        charDataLabel.text = charData
        dateLabel.text = date
    }
    
    private  func layoutViews() {
        mainView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.bottom.top.equalToSuperview()
        }
        characteristicLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(16)
        }
        charDataLabel.snp.makeConstraints {
            $0.top.equalTo(characteristicLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-16)
            $0.left.equalToSuperview().inset(16)
        }
        
        arrowImage.snp.makeConstraints {
            $0.centerY.equalTo(charDataLabel.snp.centerY)
            $0.height.equalTo(8)
            $0.width.equalTo(6)
            $0.right.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(charDataLabel.snp.centerY)
            $0.height.equalTo(16)
            $0.right.equalTo(arrowImage.snp.left).offset(-14)
        }
    }
}
