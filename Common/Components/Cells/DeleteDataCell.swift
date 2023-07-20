//
//  DeleteDataCell.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 16/03/2023.
//

import SnapKit
import UIKit

class DeleteDataCell: UITableViewCell {
    static let identifier = "DetailsDataCell"

    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .clear
        return mainView
    }()
    
    private lazy var binImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage.assetImageName(AssetsCatalog.Measurements.binIcon)
        image.tintColor = .black
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(mainView)
        mainView.addSubview(binImage)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        binImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().inset(2)
        }
    }
}
