//
//  PersistedUser+CoreDataClass.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 06/03/2023.
//
//

import Foundation
import CoreData

@objc(PersistedUser)
public class PersistedUser: NSManagedObject {
    func fillUpWith(user: User) -> PersistedUser {
        self.userID = user.userID
        self.email = user.email
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.sex = user.sex
        if let userAge = user.age, let userHeight = user.height, let userWeight = user.weight {
            self.age = Decimal(userAge) as NSDecimalNumber?
            self.height = Decimal(userHeight) as NSDecimalNumber?
            self.weight = Decimal(userWeight) as NSDecimalNumber?
        }
        return self
    }
}
