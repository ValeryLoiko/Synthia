//
//  DeviceModel.swift
//  Synthia
//
//  Created by Walery Łojko on 16/02/2023.
//

import Foundation

struct Device: Equatable {
    let deviceID: String
    let deviceName: String?
    var manufacturerName: String? 
    var serialNumber: String?
    var firmware: String?
    var modelNumber: String?
    var soleUser: Bool
}

extension Device {
    init(from persistedModel: PersistedDevice) {
        self.deviceID = persistedModel.identifier
        self.deviceName = persistedModel.name
        self.manufacturerName = persistedModel.manufacturerName
        self.serialNumber = persistedModel.serialNumber
        self.firmware = persistedModel.firmware
        self.modelNumber = persistedModel.modelNumber
        self.soleUser = persistedModel.soleUser
    }
}
