//
//  RegisterModel.swift
//  Synthia
//
//  Created by Sławek on 15/02/2023.
//

import Foundation

struct RegisterModel: Codable {
    let email: String
    let password: String
    
    private enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}
