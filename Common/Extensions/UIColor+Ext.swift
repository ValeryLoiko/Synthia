//
//  UIColor+Ext.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 23/12/2022.
//

import UIKit

// To create color, copy the hex number with "0x" prefix
// a states for alpha
extension UIColor {
    static let blackColor = UIColor(named: "blackColor")
    static let whiteColor = UIColor(named: "whiteColor")
    static let grayColor = UIColor(named: "grayColor")
    static let batteryBackgroundColor = UIColor(named: "batteryBackgroundColor")
    static let batteryTextColor = UIColor(named: "batteryTextColor")
    static let rectangleBackgroundGrayColor = UIColor(named: "rectangleBackgroundGrayColor")
    static let devicesScreenBackgroundColor = UIColor(named: "devicesScreenBackground")
    static let textfieldBackgroundColor = UIColor(named: "textfieldBackgroundColor")
}

extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            alpha: alpha
        )
    }
}
