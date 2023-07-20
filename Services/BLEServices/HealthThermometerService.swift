//
//  HealthThermometerService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 14/02/2023.
//

import Foundation
import CoreBluetooth
import RxSwift

protocol HasHealthThermometerService {
    var healthThermometerService: HealthThermometerService { get }
}

protocol HealthThermometerService {
    func observeTemperatureMeasurement() -> RxSwift.Observable<TemperatureMeasurementModel>
}

struct TemperatureMeasurementModel {
    var deviceID: String = ""
    var temperature: Float = 0
    var temperatureUnit: Units = .celsius
    var timeStamp = Date()
    var measurementID: String = UUID().uuidString
}

final class HealthThermometerServiceImpl: HealthThermometerService {
    // MARK: Properties
    
    private let bluetoothService: BLEService
    
    private enum Characteristics {
        static let temperatureMeasurementCBUUID = CBUUID(string: "2A1C")
        static let temperatureTypeCBUUID = CBUUID(string: "2A1D")
        static let intermediateTemperatureCBUUID = CBUUID(string: "2A1E")
        static let measurementIntervalCBUUID = CBUUID(string: "2A21")
    }
    
    init(bluetoothService: BLEService) {
        self.bluetoothService = bluetoothService
    }
    
    // MARK: Public Implementation
    
    func observeTemperatureMeasurement() -> RxSwift.Observable<TemperatureMeasurementModel> {
        bluetoothService.observeCharacteristics(uuid: Characteristics.temperatureMeasurementCBUUID)
            .compactMap { data in
                let deviceID = data.1
                guard let data = data.0 else { return TemperatureMeasurementModel() }
                let flagByte = [UInt8](arrayLiteral: data[0])[0]
                let flagBitValue = flagByte & 0x01
                let temperatureMeasurement = self.byteArrayToTemperatureMeasurement(dataArray: data[0...4])
                let date = self.bluetoothService.bytesToDate(dataArray: data[5...11])
                var temperatureData = TemperatureMeasurementModel()
                temperatureData.temperature = temperatureMeasurement
                switch flagBitValue {
                case 0: temperatureData.temperatureUnit = .celsius
                case 1: temperatureData.temperatureUnit = .fahrenheit
                default: temperatureData.temperatureUnit = .celsius
                }
                temperatureData.timeStamp = date
                temperatureData.deviceID = deviceID
                return temperatureData
            }
    }
    
    func byteArrayToTemperatureMeasurement(dataArray: Data) -> Float {
        let byteArray = [UInt8](dataArray)
//        let flagByte = Int(byteArray[0])
        let secondByteValue = Int(byteArray[1])
        let thirdByteValue = Int(byteArray[2]) << 8
        let unsignedByte: UInt8 = byteArray[4]
        var exponent: Int
        if unsignedByte & 0x80 != 0 {
            exponent = Int(unsignedByte) - 256
        } else {
            exponent = Int(unsignedByte)
        }
        return Float(secondByteValue + thirdByteValue) * Float(pow(10, Float(exponent)))
    }
}
