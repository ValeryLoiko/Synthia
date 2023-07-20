//
//  ToastMessagesService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 08/03/2023.
//

import UIKit
import RxSwift
import CoreBluetooth

protocol HasToastMessageService {
    var toastMessageService: ToastsMessageService { get }
}

protocol ToastsMessageService {
    func showToastMessage(type: ToastMessageType)
}

enum ToastMessageType {
    case deviceAdded
    case nameSaved
    case deviceRemoved
    case removeAllData
    case measurementDeleted
}

final class ToastMessageServiceImpl: ToastsMessageService {
    typealias T = AssetsCatalog.ToastMessage
    private let bag = DisposeBag()
    
    func showToastMessage(type: ToastMessageType) {
        guard let delegate = UIApplication.shared.delegate else { return }
        guard let window = delegate.window else { return }
        guard let window else { return }
        window.windowLevel = UIWindow.Level.alert + 1
        window.backgroundColor = .clear
        window.isHidden = false
        var toastMessage: ToastMessage
        switch type {
        case .deviceAdded:
            toastMessage = ToastMessage(style: .oneLabel, imageName: T.checkmarkIcon, mainLabelText: "New device successfully added", additionalLabelText: "")
        case .nameSaved:
            toastMessage = ToastMessage(style: .oneLabel, imageName: T.checkmarkIcon, mainLabelText: "Name saved", additionalLabelText: "")
        case .deviceRemoved:
            toastMessage = ToastMessage(style: .oneLabel, imageName: T.checkmarkIcon, mainLabelText: "Device removed", additionalLabelText: "")
        case .measurementDeleted:
            toastMessage = ToastMessage(style: .oneLabel, imageName: T.checkmarkIcon, mainLabelText: "Measurement deleted", additionalLabelText: "")
        case .removeAllData:
            toastMessage = ToastMessage(style: .oneLabel, imageName: T.checkmarkIcon, mainLabelText: "All data removed", additionalLabelText: "")
        }
        window.addSubview(toastMessage)
        
        toastMessage.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(96)
            $0.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(72)
        }
        
        Observable.just(())
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe { _ in
                toastMessage.removeFromSuperview()
            }
            .disposed(by: bag)
    }
}
