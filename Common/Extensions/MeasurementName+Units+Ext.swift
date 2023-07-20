//
//  Measurements+Units.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 24/02/2023.
//

import Foundation
extension MeasurementName {
    static func getUnitForMeasurement(measurementName: MeasurementName) -> Units {
        switch measurementName {
        case .height:
            return .meters
        case .heartRate:
            return .beatsPerMinute
        case .bloodPressure:
            return .bloodStrain
        case .diastolicPressure:
            return .bloodStrain
        case .systolicPressure:
            return .bloodStrain
        case .mpaPressure:
            return .bloodStrain
        case .oxigenSaturation:
            return .percent
        case .pulseRate:
            return .beatsPerMinute
        case .bmi:
            return .kgPerm2
        case .heartRateVariability:
            return .unknown
        case .bodyFat:
            return .kilograms
        case .muscle:
            return .kilograms
        case .water:
            return .kilograms
        case .bodyWeight:
            return .kilograms
        case .bodyTemperature:
            return .celsius
        case .boneMass:
            return .kilograms
        default:
            return .unknown
        }
    }
}
