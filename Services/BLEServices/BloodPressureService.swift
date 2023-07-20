//
//  BatteryService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 12/02/2023.
//

import Foundation
import CoreBluetooth
import RxSwift

protocol HasBloodPressureService {
    var bloodPressureService: BloodPressureService { get }
}

protocol BloodPressureService {
    func observeBloodPressure() -> Observable<BloodPressureModel>
}

struct BloodPressureModel {
    var deviceID: String = ""
    var systolicPressureMeasurement: Float = 0
    var diastolicPressureMeasurement: Float = 0
    var mpaPressureMeasurement: Float = 0
    var timeStamp = Date()
    var pulseRate: Float = 0
    var bloodPressureMeasurementUnit: Units = .mmHg
    var measurementID: String = UUID().uuidString
}

struct SystolicPressureModel {
    var deviceID: String = ""
    var systolicPressureMeasurement: Float = 0
    var timeStamp = Date()
    var bloodPressureMeasurementUnit: Units = .mmHg
}

struct DiastolicPressureModel {
    var deviceID: String = ""
    var diastolicPressureMeasurement: Float = 0
    var timeStamp = Date()
    var bloodPressureMeasurementUnit: Units = .mmHg
}

struct MpaPressureModel {
    var deviceID: String = ""
    var mpaPressureMeasurement: Float = 0
    var timeStamp = Date()
    var bloodPressureMeasurementUnit: Units = .mmHg
}

struct PulseRateModel {
    var deviceID: String = ""
    var pulseRate: Float = 0
    var timeStamp = Date()
}

final class BloodPressureServiceImpl: BloodPressureService {
    // MARK: Properties
    
    private let bluetoothService: BLEService
    
    private enum Characteristics {
        static let bloodPressureMeasurementCBUUID = CBUUID(string: "2A35")
        static let intermediateCuffPressureCBUUID = CBUUID(string: "2A36")
    }
    
    init(bluetoothService: BLEService) {
        self.bluetoothService = bluetoothService
    }
    
    // MARK: Public Implementation

    func observeBloodPressure() -> Observable<BloodPressureModel> {
        bluetoothService.observeCharacteristics(uuid: Characteristics.bloodPressureMeasurementCBUUID)
            .compactMap { data in
                let deviceID = data.1
                guard let data = data.0 else { return BloodPressureModel() }
                let flagByte = [UInt8](arrayLiteral: data[0])[0]
                let flagBitValue = flagByte & 0x01
                let systolicMeasurement = self.byteArrayToBloodPressureMeasurement(dataArray: data[1...2])
                let diastolicMeasurement = self.byteArrayToBloodPressureMeasurement(dataArray: data[3...4])
                let mpaMeasurement = self.byteArrayToBloodPressureMeasurement(dataArray: data[5...6])
                let date = self.bluetoothService.bytesToDate(dataArray: data[7...13])
                let pulseRate = self.byteArrayToPulseRateMeasurement(dataArray: data[14...15])
                var bloodPressureData = BloodPressureModel()
                bloodPressureData.systolicPressureMeasurement = systolicMeasurement
                bloodPressureData.diastolicPressureMeasurement = diastolicMeasurement
                bloodPressureData.mpaPressureMeasurement = mpaMeasurement
                bloodPressureData.timeStamp = date
                bloodPressureData.pulseRate = pulseRate
                bloodPressureData.systolicPressureMeasurement = systolicMeasurement
                switch flagBitValue {
                case 0: bloodPressureData.bloodPressureMeasurementUnit = .mmHg
                case 1: bloodPressureData.bloodPressureMeasurementUnit = .kPa
                default: bloodPressureData.bloodPressureMeasurementUnit = .mmHg
                }
                bloodPressureData.deviceID = deviceID
                return bloodPressureData
            }
    }
    
    func byteArrayToBloodPressureMeasurement(dataArray: Data) -> Float {
        let byteArray = [UInt8](dataArray)
        let firstByteValue = byteArray[0]
        let secondByteValue = byteArray[1] & 0x0F
        let exponent = byteArray[1] >> 4
        return Float(firstByteValue + secondByteValue) * Float(pow(10, Float(exponent)))
    }
    
    func byteArrayToPulseRateMeasurement(dataArray: Data) -> Float {
        let byteArray = [UInt8](dataArray)
        let firstByteValue = byteArray[0]
        let secondByteValue = byteArray[1] & 0x0F
        let exponent = byteArray[1] >> 4
        return Float(firstByteValue + secondByteValue) * Float(pow(10, Float(exponent)))
    }
}
