//
//  Encodable+Ext.swift
//  Synthia
//
//  Created by Sławek on 23/02/2023.
//

import Foundation

extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
