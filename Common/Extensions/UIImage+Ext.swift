//
//  UIImage+Ext.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 04/01/2023.
//

import UIKit

extension UIImage {
    static func assetImageName(_ name: String) -> UIImage? {
        return UIImage(named: name)
    }
}
// Example usage:
// let image = UIImage.assetImageName(AssetsCatalog.General.leftArrow)

enum SystemImages {
    enum General {
        static let leftArrow = "chevron.backward"
        static let rightArrow = "chevron.right"
        static let expandArrow = "chevron"
        static let newDeviceArrow = "NewDeviceArrow"
        static let closeImage = "xmark"
    }
    
    enum LoginFlow {
        static let googleLogo = "GoogleLogo"
    }
}

enum AssetsCatalog {
    enum General {
        static let newDeviceArrow = "NewDeviceArrow"
        static let plusIcon = "AddNewDeviceIcon"
        static let welcomeScreenImage = "WelcomeScreenImage"
        static let searchingIcon = "SearchingIcon"
    }
    
    enum ToastMessage {
        static let loadingIcon = "Loading"
        static let noInternetIcon = "NoInternet"
        static let checkmarkIcon = "Checkmark"
    }
    
    enum TabBar {
        static let tabBarMeasurements = "TabBarMeasurements"
        static let tabBarDevices = "TabBarDevices"
        static let tabBarSettings = "TabBarSettings"
    }

    enum AddDevice {
        static let bluetoothsign = "BluetoothSign"
        static let deviceImage = "TemporaryDeviceImage"
        static let searchingDeviceBackground = "SearchingDevicesBackground"
    }
    
    enum Measurements {
        static let downloadSign = "Download"
        static let measurementImage = "MeasurementIcon"
        static let binIcon = "binIcon"
    }
}
