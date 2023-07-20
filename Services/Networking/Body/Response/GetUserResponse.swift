//
//  GetUserResponse.swift
//  Synthia
//
//  Created by Sławek on 13/03/2023.
//

import Foundation

struct GetUserResponse: Codable {
    let userID: Int
    let firstName: String?
    let lastName: String?
    let age: Int?
    let sex: String?
    let height: Int?
    let email: String?
    let weight: Int?
    let pregnant: Bool?
    let periodInfo: String?
    let mandatoryInfo: String?
    let nonMandatoryInfo: String?
    let verified: Bool?
    let policy: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName = "firstName"
        case lastName = "lastName"
        case age = "age"
        case sex = "sex"
        case height = "height"
        case email = "email"
        case weight = "weight"
        case pregnant = "pregnant"
        case periodInfo = "periodInfo"
        case mandatoryInfo = "mandatoryInfo"
        case nonMandatoryInfo = "nonMandatoryInfo"
        case verified = "verified"
        case policy = "policy"
    }
}

extension GetUserResponse {
    enum Code: Int {
        case _401 = 401
    }
}
