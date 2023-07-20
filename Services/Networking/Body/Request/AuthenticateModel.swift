//
//  AuthenticateModel.swift
//  Synthia
//
//  Created by Sławek on 28/02/2023.
//

import Foundation

struct AuthenticateModel: Codable {
    let name: String
    let password: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case password
    }
}
