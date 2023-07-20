//
//  BatteryService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 12/02/2023.
//

import Foundation
import CoreBluetooth
import RxSwift

protocol HasPulseOximeterService {
    var pulseOximeterService: PulseOximeterService { get }
}

protocol PulseOximeterService {
    func observeSpotCheckMeasurement() -> RxSwift.Observable<SpotCheckMeasurementModel>
    func observeContinuousMeasurement() -> RxSwift.Observable<Float>
}

struct SpotCheckMeasurementModel {
    var deviceID: String = ""
    var oxigenSaturation: Float = 0
    var oxigenSaturationUnit: Units = .percent
    var pulseRate: Float = 0
    var pulseRateUnit: Units = .beatsPerMinute
    var timeStamp = Date()
    var measurementID: String = UUID().uuidString
}

final class PulseOximeterServiceImpl: PulseOximeterService {
    private enum Characteristics {
        static let plxSpot­CheckMeasurementCBUUID = CBUUID(string: "2A5E")
        static let plxContinuousMeasurementCBUUID = CBUUID(string: "2A5F")
    }
    
    private let bluetoothService: BLEService
    
    init(bluetoothService: BLEService) {
        self.bluetoothService = bluetoothService
    }
    
    func observeSpotCheckMeasurement() -> RxSwift.Observable<SpotCheckMeasurementModel> {
        bluetoothService.observeCharacteristics(uuid: Characteristics.plxSpot­CheckMeasurementCBUUID)
            .compactMap { data in
                let deviceID = data.1
                guard let data = data.0 else { return SpotCheckMeasurementModel() }
                let spotCheckMeasurement = self.byteArrayToMeasurement(dataArray: data)
                let pulseRate = Float(data[3])
                let date = self.bluetoothService.bytesToDate(dataArray: data[5...11])
                var spotCheckMeasurementData = SpotCheckMeasurementModel()
                spotCheckMeasurementData.oxigenSaturation = spotCheckMeasurement
                spotCheckMeasurementData.oxigenSaturationUnit = .percent
                spotCheckMeasurementData.pulseRate = pulseRate
                spotCheckMeasurementData.pulseRateUnit = .beatsPerMinute
                spotCheckMeasurementData.timeStamp = date
                spotCheckMeasurementData.deviceID = deviceID
                return spotCheckMeasurementData
            }
    }
    
    func observeContinuousMeasurement() -> RxSwift.Observable<Float> {
        bluetoothService.observeCharacteristics(uuid: Characteristics.plxContinuousMeasurementCBUUID)
            .compactMap { data in
                guard let data = data.0 else { return 0.0 }
                let continuousMeasurement = self.byteArrayToMeasurement(dataArray: data)
                self.byteArrayToPulseRate(dataArray: data)
                return continuousMeasurement
            }
    }
    
    func byteArrayToPulseRate(dataArray: Data) -> Float {
        let pulseRate = dataArray[3]
        return Float(pulseRate)
    }
    
    func byteArrayToMeasurement(dataArray: Data) -> Float {
        let byteArray = [UInt8](dataArray)
        let flagByte = Int(byteArray[0])
        let secondByteValue = Int(byteArray[1])
//        let thirdByteValue = Int(byteArray[2]) << 8
        switch flagByte {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
        return Float(secondByteValue)
    }
}
