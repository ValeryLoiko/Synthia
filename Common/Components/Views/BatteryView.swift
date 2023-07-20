//
//  BatteryView.swift
//  Synthia
//
//  Created by Walery Łojko on 20/02/2023.
//

import UIKit

class BatteryView: UIView {
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .batteryBackgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var batteryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProTextRegular12
        label.textColor = UIColor.batteryTextColor
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = .blackColor
        progressView.trackTintColor = .blackColor?.withAlphaComponent(0.3)
        let mainLineLayer = progressView.subviews[1].layer
        mainLineLayer.cornerRadius = 3
        mainLineLayer.masksToBounds = true
        let trackLineLayer = progressView.subviews[0].layer
        trackLineLayer.cornerRadius = 3
        trackLineLayer.masksToBounds = true
        return progressView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setBatteryLevel(level: Int) {
        progressView.setProgress(Float(level) / 100, animated: true)
        batteryLabel.text = "Battery: \(level)%"
    }
    
    private func setupView() {
        addSubview(mainView)
        mainView.addSubview(batteryLabel)
        mainView.addSubview(progressView)
        
        mainView.snp.makeConstraints {
            $0.width.equalTo(124)
            $0.height.equalTo(24)
            $0.centerX.equalToSuperview()
        }
        
        batteryLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.equalToSuperview().inset(12)
        }
        
        progressView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(20)
            $0.height.equalTo(4)
        }
    }
}
