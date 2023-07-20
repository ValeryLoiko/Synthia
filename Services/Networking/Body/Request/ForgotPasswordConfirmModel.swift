//
//  ForgotPasswordConfirmModel.swift
//  Synthia
//
//  Created by Sławek on 01/03/2023.
//

import Foundation

struct ForgotPasswordConfirmModel: Codable {
    let verificationCode: String
    let password: String
    let email: String
}
