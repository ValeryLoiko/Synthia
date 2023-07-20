//
//  PersistedMesurement+CoreDataProperties.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 20/02/2023.
//
//

import Foundation
import CoreData

extension PersistedMeasurement {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedMeasurement> {
        return NSFetchRequest<PersistedMeasurement>(entityName: "PersistedMesurement")
    }

    @NSManaged public var deviceID: String?
    @NSManaged public var name: String
    @NSManaged public var unit: String
    @NSManaged public var date: Date
    @NSManaged public var result: Double
    @NSManaged public var measurementID: String
}

extension PersistedMeasurement: Identifiable {
}
