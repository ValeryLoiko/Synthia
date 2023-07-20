//
//  PersistedDevice+CoreDataProperties.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 23/02/2023.
//
//

import Foundation
import CoreData

extension PersistedDevice {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedDevice> {
        return NSFetchRequest<PersistedDevice>(entityName: "PersistedDevice")
    }
    @NSManaged public var identifier: String
    @NSManaged public var name: String?
    @NSManaged public var manufacturerName: String?
    @NSManaged public var serialNumber: String?
    @NSManaged public var firmware: String?
    @NSManaged public var modelNumber: String?
    @NSManaged public var soleUser: Bool
}

extension PersistedDevice: Identifiable {
}
