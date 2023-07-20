//
//  BatteryService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 12/02/2023.
//

import Foundation
import CoreBluetooth
import RxSwift

protocol HasWeightScaleService {
    var weightScaleService: WeightScaleService { get }
}

protocol WeightScaleService {
    func observeWeightMeasurement() -> RxSwift.Observable<WeightMeasurementModel>
}

struct WeightMeasurementModel {
    var deviceID: String = ""
    var weight: Float = 0
    var weightUnit: Units = .kilograms
    var timeStamp = Date()
    var bmi: Float = 0
    var bmiUnit: Units = .kgPerm2
    var height: Float = 0
    var heightUnit: Units = .meters
    var measurementID: String = UUID().uuidString
}

final class WeightScaleServiceImpl: WeightScaleService {
    // MARK: Properties
    
    private let bluetoothService: BLEService
    
    private enum Characteristics {
        static let weightCBUUID = CBUUID(string: "2A98")
        static let weightMeasurementCBUUID = CBUUID(string: "2A9D")
    }
    
    init(bluetoothService: BLEService) {
        self.bluetoothService = bluetoothService
    }
    
    // MARK: Public Implementation
    
    func observeWeightMeasurement() -> RxSwift.Observable<WeightMeasurementModel> {
        bluetoothService.observeCharacteristics(uuid: Characteristics.weightMeasurementCBUUID)
            .compactMap { data in
                let deviceID = data.1
                guard let data = data.0 else { return WeightMeasurementModel() }
                let flagByte = [UInt8](arrayLiteral: data[0])[0]
                let weightMeasurement = self.byteArrayToWeightMeasurement(dataArray: data[0...2])
                let date = self.bluetoothService.bytesToDate(dataArray: data[3...9])
                let bmi = self.byteArrayToBMIMeasurement(dataArray: data[11...12], flagByte: Int((data)[0]))
                let heightMeasurement = self.byteArrayToHeightMeasurement(dataArray: data[13...14], flagByte: Int((data)[0]))
                var weightMeasurementData = WeightMeasurementModel()
                var weightRatio: Double = 0
                var weightUnit = Units.kilograms
                var heightRatio: Double = 0
                var heightUnit = Units.meters
                let firstBitValue = flagByte & 0x01
                switch firstBitValue {
                case 0:
                    weightRatio = 0.005
                    weightUnit = Units.kilograms
                    heightRatio = 0.001
                    heightUnit = Units.meters
                case 1:
                    weightRatio = 0.01
                    weightUnit = Units.lbs
                    heightRatio = 0.01
                    heightUnit = Units.inches
                default:
                    weightRatio = 0.005
                    weightUnit = Units.kilograms
                    heightRatio = 0.001
                    heightUnit = Units.meters
                }
                weightMeasurementData.weight = weightMeasurement * Float(weightRatio)
                weightMeasurementData.weightUnit = weightUnit
                weightMeasurementData.timeStamp = date
                weightMeasurementData.bmi = bmi
                weightMeasurementData.bmiUnit = .kgPerm2
                weightMeasurementData.height = heightMeasurement * Float(heightRatio)
                weightMeasurementData.heightUnit = heightUnit
                weightMeasurementData.deviceID = deviceID
                return weightMeasurementData
            }
    }
    
    func byteArrayToWeightMeasurement(dataArray: Data) -> Float {
        let byteArray = [UInt8](dataArray)
        let firstByteValue = Int(byteArray[1])
        let secondByteValue = Int(byteArray[2]) << 8
        return Float(firstByteValue + secondByteValue)
    }
    
    func byteArrayToBMIMeasurement(dataArray: Data, flagByte: Int) -> Float {
        let byteArray = [UInt8](dataArray)
        let firstByteValue = Int(byteArray[0])
        let secondByteValue = Int(byteArray[2]) << 8
        return Float(firstByteValue + secondByteValue)
    }
    
    func byteArrayToHeightMeasurement(dataArray: Data, flagByte: Int) -> Float {
        let byteArray = [UInt8](dataArray)
        let firstByteValue = Int(byteArray[1])
        let secondByteValue = Int(byteArray[2]) << 8
        return Float(firstByteValue + secondByteValue)
    }
}
