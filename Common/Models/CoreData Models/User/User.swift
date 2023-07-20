//
//  UserModel.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 06/03/2023.
//

import Foundation

struct User: Equatable {
    let userID: String
    let email: String
    let firstName: String?
    let lastName: String?
    let age: Int?
    let sex: String?
    let height: Int?
    let weight: Int?
}

extension User {
    init(from persistedModel: PersistedUser) {
        self.userID = persistedModel.userID
        self.email = persistedModel.email
        self.firstName = persistedModel.firstName
        self.lastName = persistedModel.lastName
        self.sex = persistedModel.sex
        self.age = persistedModel.age?.intValue
        self.height = persistedModel.height?.intValue
        self.weight = persistedModel.weight?.intValue
    }
}
