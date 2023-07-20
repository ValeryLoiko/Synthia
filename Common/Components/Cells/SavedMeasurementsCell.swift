//
//  SavedMeasurementsCell.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 02/03/2023.
//

import UIKit
import SnapKit

class SavedMeasurementsCell: UITableViewCell {
    typealias M = AssetsCatalog.Measurements
    static let identifier = "SavedMeasurementsCell"
    
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.layer.cornerRadius = 8
        return mainView
    }()
    
    private lazy var topStackView: UIStackView = {
        let contentView = UIStackView(arrangedSubviews: [measurementNameLabel, measurementTimeLabel, nowImage])
        contentView.axis = .horizontal
        contentView.backgroundColor = .clear
        contentView.spacing = 5
        return contentView
    }()
    
    private lazy var measurementNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = UIColor.blackColor
        label.textAlignment = .left
        label.font = UIFont.OpenSansSemiBold16
        return label
    }()
    
    private lazy var measurementTimeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        label.font = UIFont.OpenSansRegular14
        return label
    }()
    
    private lazy var nowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: SystemImages.General.rightArrow)
        image.tintColor = .lightGray
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let contentView = UIStackView(arrangedSubviews: [measurementResultLabel, measurementImage])
        contentView.axis = .horizontal
        contentView.backgroundColor = .clear
        contentView.distribution = .fillEqually
        return contentView
    }()
    
    private lazy var measurementResultLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = UIColor.blackColor
        label.textAlignment = .left
        label.font = UIFont.OpenSansSemiBold16
        return label
    }()
    
    private lazy var measurementImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage.assetImageName(M.measurementImage)
        image.tintColor = .blackColor
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.addSubview(topStackView)
        mainView.addSubview(bottomStackView)
        layoutViews()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(measurementName: String, measurementResult: Double, measurementResultUnit: Units, measurementDate: Date) {
        measurementNameLabel.text = measurementName
        measurementResultLabel.text = "\(measurementResult) " + measurementResultUnit.rawValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM HH:mm"
        let dateString = dateFormatter.string(from: measurementDate)
        measurementTimeLabel.text = dateString
    }
    
    private func layoutViews() {
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topStackView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        measurementNameLabel.snp.makeConstraints {
            $0.width.equalToSuperview().inset(71)
        }
        
        nowImage.snp.makeConstraints {
            $0.width.equalTo(12)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
}
