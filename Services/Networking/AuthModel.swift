//
//  AuthModel.swift
//  Synthia
//
//  Created by Sławek on 14/02/2023.
//

import Foundation

struct AuthModel: Codable {
    struct ChallengeParameter: Codable {
    }
    
    struct AuthenticationResult: Codable {
        let accessToken: String
        let expiresIn: Int
        let tokenType: String
        let refreshToken: String
        let idToken: String
        
        private enum CodingKeys: String, CodingKey {
            case accessToken = "AccessToken"
            case expiresIn = "ExpiresIn"
            case tokenType = "TokenType"
            case refreshToken = "RefreshToken"
            case idToken = "IdToken"
        }
    }
    
    let challengeParameters: ChallengeParameter
    let authenticationResult: AuthenticationResult
    
    private enum CodingKeys: String, CodingKey {
        case challengeParameters = "ChallengeParameters"
        case authenticationResult = "AuthenticationResult"
    }
}
