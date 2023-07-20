//
//  DeviceAvailableInfoView.swift
//  Synthia
//
//  Created by Walery Łojko on 03/03/2023.
//

import Foundation
import SnapKit
import UIKit

enum DetailsLabelType {
    case manufacturer
    case serialNumber
    case model
    case firmware
}

class DeviceInfoView: UIView {
    typealias  D = Localization.DeviceDetailsScreen
    lazy var mainView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.blackColor?.withAlphaComponent(0.4).cgColor
        view.layer.cornerRadius = 9
        return view
    }()
    lazy var manufacturerView = createLabelView(detailsTitle: D.manufacturer)
    lazy var serialNumberView = createLabelView(detailsTitle: D.serialNumber)
    lazy var modelView = createLabelView(detailsTitle: D.model)
    lazy var firmwareView = createLabelView(detailsTitle: D.firmware)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(mainView)
        mainView.addSubview(manufacturerView)
        mainView.addSubview(serialNumberView)
        mainView.addSubview(modelView)
        mainView.addSubview(firmwareView)
        
        mainView.snp.makeConstraints {
            $0.height.equalTo(224)
            $0.left.right.equalToSuperview()
        }
        manufacturerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        serialNumberView.snp.makeConstraints {
            $0.top.equalTo(manufacturerView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(56)
        }
        modelView.snp.makeConstraints {
            $0.top.equalTo(serialNumberView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(56)
        }
        firmwareView.snp.makeConstraints {
            $0.top.equalTo(modelView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
    func updateDetailsValueLabel(labelType: DetailsLabelType, detailsValue: String) {
        var labelToUpdate: UILabel?
        switch labelType {
        case .manufacturer:
            labelToUpdate = manufacturerView.subviews.compactMap({ $0 as? UILabel }).last
        case .serialNumber:
            labelToUpdate = serialNumberView.subviews.compactMap({ $0 as? UILabel }).last
        case .model:
            labelToUpdate = modelView.subviews.compactMap({ $0 as? UILabel }).last
        case .firmware:
            labelToUpdate = firmwareView.subviews.compactMap({ $0 as? UILabel }).last
        }
        
        labelToUpdate?.text = detailsValue
    }
    
    func createLabelView(detailsTitle: String) -> UIView {
        let detailsView = UIView()
        
        let detailsTitleLabel: UILabel = {
            let label = UILabel()
            label.text = detailsTitle
            label.font = UIFont.OpenSansSemiBold12
            label.textColor = .black
            return label
        }()
        
        let detailsValueLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.OpenSansSemiBold12
            label.textColor = UIColor.black.withAlphaComponent(0.4)
            return label
        }()
        
        let separatorLine: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            return view
        }()
        
        detailsView.addSubview(detailsTitleLabel)
        detailsView.addSubview(detailsValueLabel)
        detailsView.addSubview(separatorLine)
        
        detailsView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        detailsTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        detailsValueLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
        
        separatorLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(detailsView.snp.bottom).inset(1)
            $0.left.right.equalToSuperview().inset(8)
        }
        
        return detailsView
    }
}
