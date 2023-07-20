//
//  AtuhResponse.swift
//  Synthia
//
//  Created by Sławek on 27/02/2023.
//

import Foundation

struct AuthResponse: Decodable {
    let email: String
    let password: String
}

extension AuthResponse {
    enum Code: Int {
        case _422 = 422
    }
}
