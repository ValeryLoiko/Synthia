//
//  API.swift
//  Synthia
//
//  Created by Sławek on 23/02/2023.
//

import Foundation

enum API {
    enum Endpoint: URLRequestConvertible {
        case registerUser(email: String, password: String)
        case authenticateUser(name: String, password: String)
        case forgotPassword(email: String)
        case forgotPasswordConfirm(verificationCode: String, password: String, email: String)
        case refreshTokens(refreshToken: String)
        case hello(message: String)
        case getUsers
        case postMeasurements(newMeasurement: Measurement, userID: Int)
        case getMeasurements(beforeTime: Int?, afterTime: Int?, deviceName: String?, deviceAddress: String?, typeId: Int?)
        case updateUsers(email: String?, firstName: String?, lastName: String?, age: Int?, sex: String?, height: Int?, weight: Int?)
        case deleteUsers
        case logoutUsers(refreshToken: String)
        
        var method: HTTPMethod {
            switch self {
            case .registerUser:
                return .POST
            case .authenticateUser:
                return .POST
            case .forgotPassword:
                return .POST
            case .forgotPasswordConfirm:
                return .POST
            case .refreshTokens:
                return .POST
            case .hello:
                return .POST
            case .getUsers:
                return .GET
            case .postMeasurements:
                return .POST
            case .getMeasurements:
                return .GET
            case .updateUsers:
                return .PATCH
            case .deleteUsers:
                return .DELETE
            case .logoutUsers:
                return .POST
            }
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .registerUser:
                return nil
            case .authenticateUser:
                return nil
            case .forgotPassword:
                return nil
            case .forgotPasswordConfirm:
                return nil
            case .refreshTokens:
                return nil
            case .hello:
                return nil
            case .getUsers:
                return nil
            case .postMeasurements:
                return nil
            case .getMeasurements(beforeTime: let beforeTime, afterTime: let afterTime, deviceName: let deviceName, deviceAddress: let deviceAddress, typeId: let typeId):
                var items = [URLQueryItem]()
                if beforeTime != nil {
                    items.append(URLQueryItem(name: "beforeTime", value: "\(beforeTime)"))
                    print("Before")
                }
                if afterTime != nil {
                    items.append(URLQueryItem(name: "afterTime", value: "\(afterTime)"))
                    print("After")
                }
                if deviceName != nil {
                    items.append(URLQueryItem(name: "deviceName", value: "\(deviceName)"))
                    print("devicename")
                }
                if deviceAddress != nil {
                    items.append(URLQueryItem(name: "deviceAddress", value: "\(deviceAddress)"))
                    print("deviceaddres")
                }
                if typeId != nil {
                    items.append(URLQueryItem(name: "typeId", value: "\(typeId)"))
                    print("typeId")
                }
                return items
            case .updateUsers:
                return nil
            case .deleteUsers:
                return nil
            case .logoutUsers:
                return nil
            }
        }
        
        var pathComponents: [String] {
            switch self {
            case .registerUser:
                return ["users"]
            case .authenticateUser:
                return ["auth", "authenticate"]
            case .forgotPassword:
                return ["auth", "forgot-password"]
            case .forgotPasswordConfirm:
                return ["auth", "forgot-password-confirm"]
            case .refreshTokens:
                return ["auth", "refresh-tokens"]
            case .hello:
                return ["hello"]
            case .getUsers:
                return ["users"]
            case .postMeasurements:
                return ["measurementsResults"]
            case .getMeasurements:
                return ["measurementsResults"]
            case .updateUsers:
                return ["users"]
            case .deleteUsers:
                return ["users"]
            case .logoutUsers:
                return ["auth", "logout"]
            }
        }
        
        var parameters: Encodable? {
            switch self {
            case let .registerUser(email, password):
                return RegisterModel(email: email, password: password)
            case let .authenticateUser(name, password):
                return AuthenticateModel(name: name, password: password)
            case let .forgotPassword(email):
                return ForgotPasswordModel(email: email)
            case let .forgotPasswordConfirm(verificationCode, password, email):
                return ForgotPasswordConfirmModel(verificationCode: verificationCode, password: password, email: email)
            case let .refreshTokens(refreshToken: refreshToken):
                return RefreshTokensModel(refreshToken: refreshToken)
            case .hello(message: let message):
                return message
            case .getUsers:
                return nil
            case .postMeasurements(newMeasurement: let newMeasurement, userID: let userID):
                var unit = newMeasurement.unit.rawValue
                if unit.isEmpty {
                    unit = "unknown"
                }
                var deviceAddress = ""
                if deviceAddress.isEmpty {
                    deviceAddress = "unknown"
                } else {
                    deviceAddress = newMeasurement.deviceId ?? "unknown"
                }
                let model = MeasurementsModel(value: Int(newMeasurement.value), unit: unit, time: Int(newMeasurement.measurementDate.timeIntervalSince1970), deviceName: deviceAddress, deviceAddress: deviceAddress, userId: userID, typeId: newMeasurement.name.type)
                return model
            case .getMeasurements:
                return nil
            case .updateUsers(email: let email, firstName: let firstName, lastName: let lastName, age: let age, sex: let sex, height: let height, weight: let weight):
                return UpdateUsersModel(email: email, firstName: firstName, lastName: lastName, age: age, sex: sex, height: height, weight: weight)
            case .deleteUsers:
                return nil
            case .logoutUsers(refreshToken: let refreshToken):
                return LogoutUsersModel(refreshToken: refreshToken)
            }
        }
        
        var needsAuthorization: Bool {
            switch self {
            case .registerUser:
                return false
            case .authenticateUser:
                return false
            case .forgotPassword:
                return false
            case .forgotPasswordConfirm:
                return false
            case .refreshTokens:
                return false
            case .hello:
                return true
            case .getUsers:
                return true
            case .postMeasurements:
                return true
            case .getMeasurements:
                return true
            case .updateUsers:
                return true
            case .deleteUsers:
                return true
            case .logoutUsers:
                return true
            }
        }
        
        var additionalHeaders: [String: String] {
            switch self {
            case .registerUser:
                return [:]
            case .authenticateUser:
                return [:]
            case .forgotPassword:
                return [:]
            case .forgotPasswordConfirm:
                return [:]
            case .refreshTokens:
                return [:]
            case .hello:
                return [:]
            case .getUsers:
                return [:]
            case .postMeasurements:
                return [:]
            case .getMeasurements:
                return [:]
            case .updateUsers:
                return [:]
            case .deleteUsers:
                return [:]
            case .logoutUsers:
                return [:]
            }
        }
    }
}
