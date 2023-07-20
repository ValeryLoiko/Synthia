//
//  MeasurementName.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 23/02/2023.
//

import Foundation

enum MeasurementName: String, CaseIterable {
    case heartRate = "Heart Rate"
    case bloodPressure = "Blood Pressure"
    case diastolicPressure = "Diastolic Pressure"
    case systolicPressure = "Systolic Pressure"
    case mpaPressure = "Mpa Pressure Measurement"
    case oxigenSaturation = "Oxygen Saturation"
    case pulseRate = "Pulse Rate"
    case bmi = "BMI"
    case height = "Height"
    case heartRateVariability = "Heart rate variability"
    case bodyFat = "Body fat"
    case muscle = "Muscle mass"
    case boneMass = "Bone mass"
    case water = "Water"
    case bodyWeight = "Body Weight"
    case bodyTemperature = "Body Temperature"
    case visceralFat = "Visceral Fat"
    case moistureRate = "Moisture Rate"
    case proteinRate = "Protein Rate"
    case bodyScore = "Body Score"
    case basalMetabolism = "Basal metabolism (BMR)"
    case bodyAge = "Body Age"
    case unknown = "Other"
    
    var type: Int {
        switch self {
        case .heartRate:
            return 1
        case .bloodPressure:
            return 2
        case .oxigenSaturation:
            return 3
        case .bodyTemperature:
            return 4
        case .heartRateVariability:
            return 5
        case .pulseRate:
            return 6
        case .bodyWeight:
            return 7
        case .muscle:
            return 8
        case .boneMass:
            return 9
        case .bodyFat:
            return 10
        case .visceralFat:
            return 11
        case .moistureRate:
            return 12
        case .proteinRate:
            return 13
        case .bodyScore:
            return 14
        case .bmi:
            return 15
        case .basalMetabolism:
            return 16
        case .bodyAge:
            return 17
        case .unknown:
            return 18
        case .diastolicPressure:
            return -1
        case .systolicPressure:
            return -2
        case .mpaPressure:
            return -3
        case .height:
            return -4
        case .water:
            return -5
        }
    }
}
