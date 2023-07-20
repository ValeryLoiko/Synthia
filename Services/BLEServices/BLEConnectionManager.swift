//
//  BLEConnectionManager.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 06/03/2023.
//

import Foundation
import RxSwift
import CoreBluetooth

protocol HasBLEConnectionManager {
    var bleConnectionManager: BLEConnectionManager { get }
}

protocol BLEConnectionManager {
}

final class BLEConnectionManagerImpl: BLEConnectionManager {
    private let bag = DisposeBag()
    private let bluetoothService: BLEService
    private let devicesPersistanceService: DevicesPersistanceService
    
    init(bluetoothService: BLEService, devicesPersistanceService: DevicesPersistanceService) {
        self.bluetoothService = bluetoothService
        self.devicesPersistanceService = devicesPersistanceService
        retrieveConnection()
    }
    
    private var retrievedPeripheralArray: [CBPeripheral] = [] // for keeping strong reference
    private var uuidArray: [String] = []
    
    func retrieveConnection() {
        devicesPersistanceService.fetchAllDevices()
            .filter({ $0.count > 0 })
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .asObservable()
            .map { devices -> [UUID] in
                Array(devices).compactMap({ UUID(uuidString: $0.deviceID) })
            }
            .flatMapLatest({ uuids in
                self.enqueueConnection(uuidArray: uuids)
            })
            .timeout(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe()
            .disposed(by: bag)
        }
    
    func enqueueConnection(uuidArray: [UUID]) -> Single<Void> {
        var uuidArray = uuidArray
        let firstUUID = uuidArray.removeFirst()
        return uuidArray.reduce(bluetoothService.autoReconnect(identifier: firstUUID)) { partialResult, nextUUID -> Completable in
            return partialResult.andThen(bluetoothService.autoReconnect(identifier: nextUUID))
        }
        .andThen(.just(()))
    }
}
