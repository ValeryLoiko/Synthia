//
//  UserManager.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 22/03/2023.
//

import Foundation
import RxSwift
import RxRelay

protocol HasUserManager {
    var userManager: UserManager { get }
}

protocol UserManager {
    func setUserInfo()
    func login(email: String, password: String) -> Completable
    func logOut() -> Completable 
    func deleteAccount() -> Completable
}

final class UserManagerImpl: UserManager {
    private let keychainManager: KeychainManagerService
    private let networkingService: NetworkingService
    private let accessManager: AccessManager
    private let devicesPersistanceService: DevicesPersistanceService
    private let measurementsPersistanceService: MeasurementsPersistanceService
    private let bag = DisposeBag()
    
    init(keychainManager: KeychainManagerService, networkingService: NetworkingService, accessManager: AccessManager, devicesPersistanceService: DevicesPersistanceService, measurementsPersistanceService: MeasurementsPersistanceService) {
        self.keychainManager = keychainManager
        self.networkingService = networkingService
        self.accessManager = accessManager
        self.devicesPersistanceService = devicesPersistanceService
        self.measurementsPersistanceService = measurementsPersistanceService
    }
    
    func deleteAllData() {
        measurementsPersistanceService.deleteAllMeasurements()
        devicesPersistanceService.deleteAllDevices()
    }
    
    func setUserInfo() {
        keychainManager.removeUserInfo()
        networkingService.execute(request: API.Endpoint.getUsers, decodingFormat: .json)
            .do(onSuccess: { (response: [GetUserResponse]) in
                self.deleteAllData()
                let response = response[0]
                let userInfo = UserInfo(firstName: response.firstName, lastName: response.lastName, age: response.age, sex: response.sex, height: response.height, email: response.email, weight: response.weight, userID: response.userID)
                self.keychainManager.setUserInfo(userInfo: userInfo)
                self.accessManager.userLoggedIn()
                print(self.keychainManager.getToken() ?? "")
            },
                onError: { _ in
                self.accessManager.unregisteredUser()
            })
                .subscribe()
                .disposed(by: bag)
    }
    
    func login(email: String, password: String) -> Completable {
        return networkingService.execute(request: API.Endpoint.authenticateUser(name: email, password: password), decodingFormat: .json)
            .do(onSuccess: { (response: [AuthModelResponse]) in
                let response = response[0]
                self.deleteAllData()
                self.keychainManager.setToken(token: response.authenticationResult.accessToken)
                self.keychainManager.setRefreshToken(refreshToken: response.authenticationResult.refreshToken)
                self.accessManager.userLoggedIn()
                self.setUserInfo()
            },
                onError: { _ in
                self.accessManager.unregisteredUser()
            })
                .asCompletable()
    }
    
    func logOut() -> Completable {
        let refreshToken = keychainManager.getRefreshToken() ?? ""
        return networkingService.execute(request: API.Endpoint.logoutUsers(refreshToken: refreshToken), decodingFormat: .json)
            .do(onSuccess: { (_: [LogoutUsersResponse]) in
                self.deleteAllData()
                self.keychainManager.removeToken()
                self.keychainManager.removeRefreshToken()
                self.accessManager.unregisteredUser()
                self.keychainManager.removeUserInfo()
            })
                .asCompletable()
    }
    
    func deleteAccount() -> Completable {
        return networkingService.execute(request: API.Endpoint.deleteUsers, decodingFormat: .json)
            .do(onSuccess: { (_: [GetUserResponse]) in
                self.keychainManager.removeToken()
                self.keychainManager.removeRefreshToken()
            })
                .asCompletable()
    }
}
