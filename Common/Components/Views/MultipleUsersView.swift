//
//  MultipleUsersView.swift
//  Synthia
//
//  Created by Walery Łojko on 28/02/2023.
//

import Foundation
import UIKit

class MultipleUsersView: UIView {
    typealias D = Localization.DeviceDetailsScreen
    private lazy var mainView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.blackColor?.withAlphaComponent(0.4).cgColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = D.multipleUserstitle
        label.font = UIFont.OpenSansSemiBold14
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var questionView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.blackColor?.cgColor
        view.layer.cornerRadius = 7
        
        let label = UILabel()
        label.text = "?"
        label.font = UIFont.OpenSansSemiBold12
        label.textColor = UIColor.black
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        return view
    }()
    
    lazy var mySwitch: UISwitch = {
       let isSwitch = UISwitch()
        return isSwitch
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(mainView)
        mainView.addSubview(label)
        mainView.addSubview(questionView)
        mainView.addSubview(mySwitch)
        
        mainView.snp.makeConstraints {
            $0.height.equalTo(56)
           $0.left.right.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalTo(mainView)
            $0.left.equalTo(16)
        }
        questionView.snp.makeConstraints {
            $0.centerY.equalTo(mainView)
            $0.height.width.equalTo(14)
            $0.left.equalTo(label.snp.right).offset(9)
        }
        
        mySwitch.snp.makeConstraints {
            $0.centerY.equalTo(mainView)
            $0.right.equalToSuperview().offset(-16)
        }
    }
}
