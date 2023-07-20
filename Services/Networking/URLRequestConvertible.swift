//
//  URLRequestConvertible.swift
//  Synthia
//
//  Created by Sławek on 23/02/2023.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

protocol URLRequestConvertible {
    typealias Headers = [String: String]
    typealias Parameters = [String: AnyObject]
    
    var url: URL? { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var pathComponents: [String] { get }
    var httpBody: Data? { get }
    var parameters: Encodable? { get }
    var request: URLRequest { get }
    var needsAuthorization: Bool { get }
    var additionalHeaders: [String: String] { get }
}

extension URLRequestConvertible {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Config.apiURL
        components.path = "/" + pathComponents.joined(separator: "/")
        return components.url
    }
    
    var httpBody: Data? {
        return parameters?.toJSONData()
    }
        
    var request: URLRequest {
        guard let url = url else {
            fatalError("Failed to process URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let httpBody = httpBody {
            request.httpBody = httpBody
        }
        for entry in additionalHeaders {
            request.setValue(entry.value, forHTTPHeaderField: entry.key)
        }
        return request
    }
}
