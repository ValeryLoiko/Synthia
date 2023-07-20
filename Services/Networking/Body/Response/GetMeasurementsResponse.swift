//
//  GetMeasurementsResponse.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 23/03/2023.
//

import Foundation
struct GetMeasurementsResponse: Codable {
    let value: Int
    let unit: String
    let time: String
    let deviceName: String
    let deviceAddress: String
    let userId: Int
    let typeId: Int
    let id: Int
}

extension GetMeasurementsResponse {
    enum Code: Int {
        case _404 = 404
    }
}
