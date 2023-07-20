//
//  BatteryService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 12/02/2023.
//

import Foundation
import CoreBluetooth
import RxSwift

protocol HasBatteryService {
    var batteryService: BatteryService { get }
}

protocol BatteryService {
    func observeBatteryLevel() -> RxSwift.Observable<BatteryLevelModel>
    var batteryLevelObservable: RxSwift.Observable<Float> { get }
}

struct BatteryLevelModel {
    var deviceID: String = ""
    var batteryLevelMeasurement: Float = 0
    var batteryLevelMeasurementUnit: Units = .percent
}

final class BatteryServiceImpl: BatteryService {
    // MARK: Properties
    
    private let bluetoothService: BLEService
    private var batteryLevelSubject = PublishSubject<Float>()
    var batteryLevelObservable: RxSwift.Observable<Float> { return batteryLevelSubject }
    
    private enum Characteristics {
        static let batteryLevelCBUUID = CBUUID(string: "2A19")
    }
    
    init(bluetoothService: BLEService) {
        self.bluetoothService = bluetoothService
    }
    
    // MARK: Public Implementation
    
    func observeBatteryLevel() -> RxSwift.Observable<BatteryLevelModel> {
        bluetoothService.observeCharacteristics(uuid: Characteristics.batteryLevelCBUUID)
            .compactMap { data in
                let deviceID = data.1
                guard let data = data.0 else { return BatteryLevelModel() }
                let batteryLevel = data[0]
                let percentageBatteryLevel = Float(batteryLevel) / 100.0
                var batteryLevelData = BatteryLevelModel()
                batteryLevelData.batteryLevelMeasurement = percentageBatteryLevel
                batteryLevelData.batteryLevelMeasurementUnit = .percent
                batteryLevelData.deviceID = deviceID
                return batteryLevelData
            }
    }
}
