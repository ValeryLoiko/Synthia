//
//  KeychainManager.swift
//  Synthia
//
//  Created by Sławek on 23/02/2023.
//

import Foundation
import KeychainAccess

protocol HasKeychainManager {
    var keychainManager: KeychainManagerService { get }
}

protocol KeychainManagerService {
    func hasToken() -> Bool
    func hasRefreshToken() -> Bool
    func getToken() -> String?
    func getRefreshToken() -> String?
    func getUserInfo() -> UserInfo?
    func setToken(token: String)
    func setRefreshToken(refreshToken: String)
    func setUserInfo(userInfo: UserInfo)
    func removeToken()
    func removeRefreshToken()
    func removeUserInfo()
}

final class KeychainManagerImpl: KeychainManagerService {
    private let keychain: Keychain
    
    private enum KeychainServiceKeys {
        static let token_key = "synthia.access_token"
        static let token_refresh_key = "synthia.refresh_token"
        static let token_service = "synthia.token"
        static let user_info = "synthia.user_info"
    }
    
    init() {
        self.keychain = Keychain(service: KeychainServiceKeys.token_service)
    }
    
    func hasToken() -> Bool {
        let hasToken = keychain[KeychainServiceKeys.token_key] != nil
        return hasToken
    }
    
    func hasRefreshToken() -> Bool {
        let hasRefreshToken = keychain[KeychainServiceKeys.token_refresh_key] != nil
        return hasRefreshToken
    }
    
    func getToken() -> String? {
        let token = try? keychain.get(KeychainServiceKeys.token_key)
        return token
    }
    
    func getRefreshToken() -> String? {
        let refreshToken = try? keychain.get(KeychainServiceKeys.token_refresh_key)
        return refreshToken
    }
    
    func getUserInfo() -> UserInfo? {
        guard let data = try? keychain.getData(KeychainServiceKeys.user_info),
                let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data) else {
              return nil
          }
          return userInfo
    }
    
    func setToken(token: String) {
        try? keychain.set(token, key: KeychainServiceKeys.token_key)
    }
    
    func setRefreshToken(refreshToken: String) {
        try? keychain.set(refreshToken, key: KeychainServiceKeys.token_refresh_key)
    }
    
    func setUserInfo(userInfo: UserInfo) {
        guard let data = try? JSONEncoder().encode(userInfo) else { return }
        try? keychain.set(data, key: KeychainServiceKeys.user_info)
    }
    
    func removeToken() {
        try? keychain.remove(KeychainServiceKeys.token_key)
    }
    
    func removeRefreshToken() {
        try? keychain.remove(KeychainServiceKeys.token_refresh_key)
    }
    
    func removeUserInfo() {
        try? keychain.remove(KeychainServiceKeys.user_info)
    }
}
