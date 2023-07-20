//
//  PersistedDevice+CoreDataClass.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 23/02/2023.
//
//

import Foundation
import CoreData

@objc(PersistedDevice)
public class PersistedDevice: NSManagedObject {
    func fillUpWith(device: Device) -> PersistedDevice {
        self.identifier = device.deviceID
        self.name = device.deviceName
        self.manufacturerName = device.manufacturerName
        self.serialNumber = device.serialNumber
        self.firmware = device.firmware
        self.modelNumber = device.modelNumber
        self.soleUser = device.soleUser
        return self
    }
}
