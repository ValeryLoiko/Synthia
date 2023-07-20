//
//  PersistedMesurement+CoreDataClass.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 20/02/2023.
//
//

import Foundation
import CoreData

@objc(PersistedMeasurement)
public class PersistedMeasurement: NSManagedObject {
    func fillUpWith(measurement: Measurement) -> PersistedMeasurement {
        self.deviceID = measurement.deviceId
        self.name = measurement.name.rawValue
        self.unit = measurement.unit.rawValue
        self.date = measurement.measurementDate
        self.result = measurement.value
        self.measurementID = measurement.measurementID
        return self
    }
}
