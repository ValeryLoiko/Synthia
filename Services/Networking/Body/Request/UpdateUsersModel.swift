//
//  UpdateUsersModel.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 22/03/2023.
//

import Foundation

struct UpdateUsersModel: Codable {
    let email: String?
    let firstName: String?
    let lastName: String?
    let age: Int?
    let sex: String?
    let height: Int?
    let weight: Int?
}
