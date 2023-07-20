//
//  BodyCompositionService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 15/02/2023.
//

import Foundation
import CoreBluetooth
import RxSwift

protocol HasBodyCompositionService {
    var bodyCompositionService: BodyCompositionService { get }
}

protocol BodyCompositionService {
    func observeBodyCompositionMeasurement() -> RxSwift.Observable<BodyCompositionModel>
}

struct BodyCompositionModel {
    var deviceID: String = ""
    var timeStamp = Date()
    var weight: Float = 0
    var weightUnit: Units = .kilograms
    var measurementID: String = UUID().uuidString
}

final class BodyCompositionServiceImpl: BodyCompositionService {
    private enum Characteristics {
        static let bodyCompositionMeasurementCBUUID = CBUUID(string: "2A9C")
    }
    
    private let bluetoothService: BLEService
    
    init(bluetoothService: BLEService) {
        self.bluetoothService = bluetoothService
    }
    
    func observeBodyCompositionMeasurement() -> RxSwift.Observable<BodyCompositionModel> {
        bluetoothService.observeCharacteristics(uuid: Characteristics.bodyCompositionMeasurementCBUUID)
            .compactMap { data in
                let deviceID = data.1
                guard let data = data.0 else { return BodyCompositionModel() }
                let flagByte = [UInt8](arrayLiteral: data[0])[0]
                let date = self.bluetoothService.bytesToDate(dataArray: data[5...11])
                let weightMeasurement = self.byteArrayToWeightMeasurement(dataArray: data[27...28])
                var bodyCompositionData = BodyCompositionModel()
                var weightRatio: Double = 0
                var weightUnit = Units.kilograms
                let firstBitValue = flagByte & 0x01
                switch firstBitValue {
                case 0:
                    weightRatio = 0.005
                    weightUnit = Units.kilograms
                case 1:
                    weightRatio = 0.01
                    weightUnit = Units.lbs
                default:
                    weightRatio = 0.005
                    weightUnit = Units.kilograms
                }
                bodyCompositionData.deviceID = deviceID
                bodyCompositionData.timeStamp = date
                bodyCompositionData.weight = weightMeasurement * Float(weightRatio)
                bodyCompositionData.weightUnit = weightUnit
                return bodyCompositionData
            }
    }

    func byteArrayToWeightMeasurement(dataArray: Data) -> Float {
        let byteArray = [UInt8](dataArray)
        let firstByteValue = Int(byteArray[1])
        let secondByteValue = Int(byteArray[2]) << 8
        return Float(firstByteValue + secondByteValue)
    }
}
