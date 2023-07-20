//
//  MeasurementsResponse.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 21/03/2023.
//

import Foundation
struct MeasurementsResponse: Codable {
    let value: Int
    let unit: String
    let time: Int
    let deviceName: String
    let deviceAddress: String
    let userId: Int
    let typeId: Int
    let id: Int
}
