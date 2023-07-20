//
//  BatteryService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 12/02/2023.
//

import Foundation
import CoreBluetooth
import RxSwift

protocol HasHeartRateService {
    var heartRateService: HeartRateService { get }
}

protocol HeartRateService {
    func observeHeartRateMeasurement() -> Observable<HeartRateModel>
    func observeBodySensorLocation() -> RxSwift.Observable<String>
}

struct HeartRateModel {
    var deviceID: String = ""
    var heartRateMeasurement: Int = 0
    var heartRateMeasurementUnit: Units = .beatsPerMinute
    var measurementID: String = UUID().uuidString
}

final class HeartRateServiceImpl: HeartRateService {
    // MARK: Properties
    
    private let bluetoothService: BLEService
    
    private enum Characteristics {
        static let heartRateMeasurementCBUUID = CBUUID(string: "2A37")
        static let bodySensorLocationCBUUID = CBUUID(string: "2A38")
        static let heartRateControlPointCBUUID = CBUUID(string: "2A39")
    }
    
    init(bluetoothService: BLEService) {
        self.bluetoothService = bluetoothService
    }
    
    // MARK: Public Implementation
    
    func observeHeartRateMeasurement() -> RxSwift.Observable<HeartRateModel> {
        bluetoothService.observeCharacteristics(uuid: Characteristics.heartRateMeasurementCBUUID)
            .compactMap { data in
                let deviceID = data.1
                guard let data = data.0 else { return HeartRateModel(heartRateMeasurement: 0)}
                var heartRateData = HeartRateModel()
                let byteArray = [UInt8](data)
                
                let firstBitValue = byteArray[0] & 0x01
                var heartRateMeasurement: Int
                if firstBitValue == 0 {
                    heartRateMeasurement = Int(byteArray[1])
                } else {
                    heartRateMeasurement = (Int(byteArray[1] << 8) + Int(byteArray[2]))
                }
                heartRateData.heartRateMeasurement = heartRateMeasurement
                heartRateData.deviceID = deviceID
                return heartRateData
            }
    }
    
    func observeBodySensorLocation() -> RxSwift.Observable<String> {
        bluetoothService.observeCharacteristics(uuid: Characteristics.bodySensorLocationCBUUID)
            .compactMap { data in
                _ = data.1
                guard let data = data.0, let byte = data.first else { return nil}
                switch byte {
                case 0: return "Other"
                case 1: return "Chest"
                case 2: return "Wrist"
                case 3: return "Finger"
                case 4: return "Hand"
                case 5: return "Ear Lobe"
                case 6: return "Foot"
                default: return "Reserved for future use"
                }
            }
            .debug("Body sensor location")
    }
}
