//
//  NetworkingService.swift
//  Synthia
//
//  Created by Sławek on 13/02/2023.
//

import Foundation
import RxSwift

enum ApiError: Error {
    case statusCode(Int)
}

enum NetworkingError: LocalizedError {
    case emptyBody
    case statusCodeNot200
    case invalidData
    case stringDecodingError
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .emptyBody:
            return "EMPTY BODY"
        case .statusCodeNot200:
            return "Wrong status code"
        case .invalidData:
            return "Invaild Data"
        case .stringDecodingError:
            return "Erorr String"
        case .unauthorized:
            return "Unauthorized"
        }
    }
}

enum DecodingFormat {
    case json
    case string
    case jsonArray
}

protocol HasNetworkingService {
    var networkingService: NetworkingService { get }
}

protocol NetworkingService {
    func execute<T: Decodable>(request: URLRequestConvertible, decodingFormat: DecodingFormat) -> Single<[T]>
}

final class NetworkingServiceImpl: NetworkingService {
    private let keychainManager: KeychainManagerService
    private let accessManager: AccessManager
    
    init(keychainManager: KeychainManagerService, accessManager: AccessManager) {
        self.keychainManager = keychainManager
        self.accessManager = accessManager
    }
    
    func execute<T>(request: URLRequestConvertible, decodingFormat: DecodingFormat) -> Single<[T]> where T: Decodable {
        let task: Single<[T]> = URLSession.shared.dataTaskSingle(with: request, keychainManager: keychainManager, decodingFormat: decodingFormat)
        return task
            .catch({ error -> Single<[T]> in
                guard let error = error as? NetworkingError else { return .error(error)}
                switch error {
                case .unauthorized:
                    return self.refreshToken()
                        .andThen(task)
                default:
                    return .error(error)
                }
            })
                .observe(on: MainScheduler.instance)
    }
    
    private func refreshToken() -> Completable {
        let refreshToken = self.keychainManager.getRefreshToken() ?? ""
        let request = API.Endpoint.refreshTokens(refreshToken: refreshToken)
        return URLSession.shared.dataTaskSingle(with: request, keychainManager: keychainManager, decodingFormat: .json)
            .do(onSuccess: { (response: [RefreshTokenResponse]) in
                let response = response[0].authenticationResult
                self.keychainManager.removeToken()
                self.keychainManager.setToken(token: response.accessToken)
                self.accessManager.userLoggedIn()
            },
                 onError: { _ in
                self.accessManager.unregisteredUser()
            })
            .asCompletable()
    }
}
// MARK: Decoding Json and String

extension URLSession {
    func dataTaskSingle<T: Decodable>(with request: URLRequestConvertible, keychainManager: KeychainManagerService, decodingFormat: DecodingFormat) -> Single<[T]> {
        return Single<[T]>.create { single in
            var urlRequest = request.request
            if request .needsAuthorization {
                if let accessToken = keychainManager.getToken() {
                    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                } else {
                    single(.failure(NetworkingError.unauthorized))
                    return Disposables.create()
                }
            }
                        
            self.dataTask(with: urlRequest) { data, response, error in
                if let error {
                    single(.failure(error))
                    return
                }
                
                if let htttpURLResponse = response as? HTTPURLResponse {
                    switch htttpURLResponse.statusCode {
                    case 200...299:
                        break
                    case 401:
                        single(.failure(NetworkingError.unauthorized))
                        return
                    case 400:
                        break
                    default:
                        single(.failure(ApiError.statusCode(htttpURLResponse.statusCode)))
                        return
                    }
                }
                
                switch decodingFormat {
                case .json:
                    let decoder = JSONDecoder()
                    do {
                        let dataResponse = try decoder.decode(T.self, from: data ?? Data())
                        single(.success([dataResponse]))
                    } catch {
                        single(.failure(error))
                    }
                case .string:
                    if let data = data, let stringResponse = String(data: data, encoding: .utf8) as? T {
                        single(.success([stringResponse]))
                    } else {
                        single(.failure(NetworkingError.stringDecodingError))
                    }
                case .jsonArray:
                    let decoder = JSONDecoder()
                    do {
                        let dataResponse = try decoder.decode([T].self, from: data ?? Data())
                        single(.success(dataResponse))
                    } catch {
                        single(.failure(error))
                    }
                }
            } .resume()
            return Disposables.create()
        }
    }
}
