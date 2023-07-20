//
//  AccessManager.swift
//  Synthia
//
//  Created by Sławek on 15/02/2023.
//

import Foundation
import RxSwift
import RxRelay

protocol HasAccessManager {
    var accessManager: AccessManager { get }
}

protocol AccessManager {
    func userLoggedIn()
    func unregisteredUser()
    var userStateRelay: BehaviorRelay<UserState> { get }
    var userState: UserState { get }
}

enum UserState {
    case unknown
    case unregistered
    case loggedIn
}

final class AccessManagerImpl: AccessManager {
    private let keychainManager: KeychainManagerService
    
    var userStateRelay: RxRelay.BehaviorRelay<UserState> = .init(value: .unknown)
    var userState: UserState = .unregistered
    
    init(keychainManager: KeychainManagerService) {
        self.keychainManager = keychainManager
    }
    
    func userLoggedIn() {
        userStateRelay.accept(.loggedIn)
        userState = .loggedIn
    }
    
    func unregisteredUser() {
        userStateRelay.accept(.unregistered)
        userState = .unregistered
    }
}
