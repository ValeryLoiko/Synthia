//
//  Ns.swift
//  Synthia
//
//  Created by Sławek on 12/01/2023.
//

import UIKit

extension NSAttributedString {
    static func createAttributedString(text: String?, color: UIColor?, font: UIFont?) -> NSAttributedString {
        let stringAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color ?? UIColor.black,
                                                               NSAttributedString.Key.font: font as Any]
        let attributedString = NSAttributedString(string: text ?? "", attributes: stringAttributes)
        return attributedString
    }
}
