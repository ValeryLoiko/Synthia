//
//  ForgotPasswordResponse.swift
//  Synthia
//
//  Created by Sławek on 01/03/2023.
//

import Foundation

struct ForgotPasswordResponse: Codable {
    struct CodeDeliveryDetail: Codable {
        let destination: String
        let deliveryMedium: String
        let attributeName: String
        
        private enum CodingKeys: String, CodingKey {
            case destination = "Destination"
            case deliveryMedium = "DeliveryMedium"
            case attributeName = "AttributeName"
        }
    }
    
    let codeDeliveryDetails: CodeDeliveryDetail
    
    private enum CodingKeys: String, CodingKey {
        case codeDeliveryDetails = "CodeDeliveryDetails"
    }
}
