//
//  Error.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 08/02/2023.
//

import Foundation

enum BluetoothError: Swift.Error, Equatable {
    case centralManagerError
    case characteristicDataError
    case couldntRetrieveDeviceError
}

enum KeychainError: Error {
    case noUserInfo
}

enum SyncError: Error {
    case unregisteredUser
}
