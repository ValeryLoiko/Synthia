//
//  Alert+Ext.swift
//  Synthia
//
//  Created by Walery Łojko on 11/01/2023.
//

import UIKit

enum AlertType {
    case removeDevice(removeDeviceAction: ((UIAlertAction) -> Void)?, removeDeviceDataAction: ((UIAlertAction) -> Void)?)
    case oneButtonOK(title: String, message: String)
    case twoBtnsAlert(title: String, message: String, rightBtnTitle: String, rightBtnStyle: UIAlertAction.Style, rightBtnAction: ((UIAlertAction) -> Void)?)
    case twoBtnActionSheet(title: String, message: String, upBtnTitle: String, downBtnTitle: String, upBtnAction: ((UIAlertAction) -> Void)?, downBtnAction: ((UIAlertAction) -> Void)?)
}

extension UIViewController {
    typealias L = Localization
    
    func chooseAlert(type: AlertType) {
        switch type {
        case .removeDevice(let removeDeviceAction, let removeDeviceDataAction):
            let alert = UIAlertController(title: L.Alerts.removeDeviceTitle, message: L.Alerts.removeDeviceMessage, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: L.Alerts.removeDeviceDevice, style: .default, handler: removeDeviceAction))
            alert.addAction(UIAlertAction(title: L.Alerts.removeDeviceDeviceData, style: .default, handler: removeDeviceDataAction))
            alert.addAction(UIAlertAction(title: L.Alerts.cancel, style: .default))
            self.present(alert, animated: true)
            
        case .oneButtonOK(title: let title, message: let message):
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
        case .twoBtnsAlert(title: let title, message: let message, rightBtnTitle: let rightBtnTitle, rightBtnStyle: let rightBtnStyle, rightBtnAction: let rightBtnAction):
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            alert.addAction(UIAlertAction(title: rightBtnTitle, style: rightBtnStyle, handler: rightBtnAction))
            self.present(alert, animated: true)
            
        case .twoBtnActionSheet(title: let title, message: let message, upBtnTitle: let upBtnTitle, downBtnTitle: let downBtnTitle, upBtnAction: let upBtnAction, downBtnAction: let downBtnAction):
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: upBtnTitle, style: .default, handler: upBtnAction))
            alert.addAction(UIAlertAction(title: downBtnTitle, style: .default, handler: downBtnAction))
            self.present(alert, animated: true)
        }
    }
}
