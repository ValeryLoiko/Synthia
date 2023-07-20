//
//  PersonalDetailView.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 14/03/2023.
//

import UIKit
import SnapKit

class PersonalDetailView: UIView {
    private lazy var mainView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [detailNameLabel, detailValueLabel])
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.backgroundColor = .clear
        view.spacing = 17
        return view
    }()
    
    private lazy var detailNameLabel: UILabel = {
        let label = UILabel()
        label.font = .OpenSansSemiBold14
        label.textAlignment = .left
        return label
    }()
    
    private lazy var detailValueLabel: UILabel = {
        let label = UILabel()
        label.font = .OpenSansSemiBold14
        label.textAlignment = .right
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDataInput(detailName: String, detailValue: String, isSeparatorNeeded: Bool) {
        detailNameLabel.text = detailName
        detailValueLabel.text = detailValue
        if isSeparatorNeeded {
            addSubview(separatorView)
            separatorView.snp.makeConstraints {
                $0.top.equalTo(mainView.snp.bottom)
                $0.left.right.equalToSuperview().inset(8)
                $0.height.equalTo(1)
            }
        }
    }
    
    private func setupView() {
        addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}
