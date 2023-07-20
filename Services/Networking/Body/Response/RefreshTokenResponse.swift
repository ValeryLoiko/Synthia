//
//  RefreshTokenResponse2.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 21/03/2023.
//

import Foundation
struct RefreshTokenResponse: Codable {
    struct ChallengeParameter: Codable {
    }
    
    struct AuthenticationResult: Codable {
        let accessToken: String
        let expiresIn: Int
        let tokenType: String
        let idToken: String
        
        private enum CodingKeys: String, CodingKey {
            case accessToken = "AccessToken"
            case expiresIn = "ExpiresIn"
            case tokenType = "TokenType"
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
