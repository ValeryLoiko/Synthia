//
//  DeviceNameCell.swift
//  Synthia
//
//  Created by Walery Łojko on 20/02/2023.
//

import Foundation
import UIKit

class DeviceNameCell: UITableViewCell {
    static let identifier = "DeviceNameCell"
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var parameterName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.OpenSansRegular14
        label.textColor = .blackColor
        return label
    }()
    
    private lazy var parameterValue: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.OpenSansRegular14
        label.textColor = UIColor.blackColor?.withAlphaComponent(0.4)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(mainView)
        mainView.addSubview(parameterName)
        mainView.addSubview(parameterValue)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(characteristic: String, status: String) {
        parameterName.text = characteristic
        parameterValue.text = status
    }
    
    private func layoutViews() {
        mainView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        parameterName.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(16)
        }
        
        parameterValue.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(16)
        }
    }
}
