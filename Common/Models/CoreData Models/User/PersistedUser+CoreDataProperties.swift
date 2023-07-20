//
//  PersistedUser+CoreDataProperties.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 06/03/2023.
//
//

import Foundation
import CoreData

extension PersistedUser {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedUser> {
        return NSFetchRequest<PersistedUser>(entityName: "PersistedUser")
    }
    @NSManaged public var userID: String
    @NSManaged public var email: String
    @NSManaged public var age: NSDecimalNumber?
    @NSManaged public var sex: String?
    @NSManaged public var height: NSDecimalNumber?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
}

extension PersistedUser: Identifiable {
}
