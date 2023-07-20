//
//  PersonalDetailsTable.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 15/03/2023.
//

import UIKit
import SnapKit

class PersonalDetailsTable: UIView {
    typealias L = Localization.PersonalDetailsScreen
    
    private lazy var mainView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [firstNameView, lastNameView, ageButton, sexButton, heightButton, weightButton])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var firstNameView = PersonalDetailView()
    private lazy var lastNameView = PersonalDetailView()
    lazy var ageButton = PersonalDetailButton()
    lazy var sexButton = PersonalDetailButton()
    lazy var heightButton = PersonalDetailButton()
    lazy var weightButton = PersonalDetailButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabels(firstName: String, lastName: String, age: String?, sex: String, height: String?, weight: String?) {
        firstNameView.configureDataInput(detailName: L.firstName, detailValue: firstName, isSeparatorNeeded: true)
        lastNameView.configureDataInput(detailName: L.lastName, detailValue: lastName, isSeparatorNeeded: true)
        ageButton.configureDataInput(detailName: L.age, detailValue: age ?? L.unassignedValue, isArrowPresent: true, isSeparatorNeeded: true)
        sexButton.configureDataInput(detailName: L.sex, detailValue: sex, isArrowPresent: true, isSeparatorNeeded: true)
        heightButton.configureDataInput(detailName: L.height, detailValue: height ?? L.unassignedValue, isArrowPresent: true, isSeparatorNeeded: true)
        weightButton.configureDataInput(detailName: L.weight, detailValue: weight ?? L.unassignedValue, isArrowPresent: true, isSeparatorNeeded: false)
    }
    
    private func setupView() {
        addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}
