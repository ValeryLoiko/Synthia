//
//  MeasurementsModel.swift
//  Synthia
//
//  Created by Walery Łojko on 13/02/2023.
//

import Foundation

struct Measurement: Equatable {
    let deviceId: String?
    var name: MeasurementName
    let value: Double
    let unit: Units
    let measurementDate: Date
    let measurementID: String
}

extension Measurement {
    init(from response: GetMeasurementsResponse) {
        self.name = .unknown
        for measurement in MeasurementName.allCases {
            if measurement.type == response.typeId {
                self.name = measurement
            }
        }
        if let timeInterval = Double(response.time) {
            let date = Date(timeIntervalSince1970: timeInterval)
            self.measurementDate = date
        } else {
            self.measurementDate = Date()
        }
        self.deviceId = response.deviceAddress
        self.unit = Units(rawValue: response.unit) ?? .unknown
        self.value = Double(response.value)
        self.measurementID = String(response.id)
    }
}

extension Measurement {
    init(from persistedModel: PersistedMeasurement) {
        if let name = MeasurementName(rawValue: persistedModel.name), let unit = Units(rawValue: persistedModel.unit) {
            self.unit = unit
            self.name = name
        } else {
            self.unit = .unknown
            self.name = .unknown
        }
        self.deviceId = persistedModel.deviceID ?? ""
        self.value = persistedModel.result
        self.measurementDate = persistedModel.date
        self.measurementID = persistedModel.measurementID
    }
}

extension Measurement {
    init(bodyTemperature output: TemperatureMeasurementModel) {
        self.name = .bodyTemperature
        self.deviceId = output.deviceID
        self.unit = output.temperatureUnit
        self.measurementDate = output.timeStamp
        self.value = round(10 * Double(output.temperature)) / 10
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(bloodPressure output: BloodPressureModel) {
        self.name = .bloodPressure
        self.deviceId = output.deviceID
        self.unit = output.bloodPressureMeasurementUnit
        self.measurementDate = output.timeStamp
        self.value = Double(output.diastolicPressureMeasurement)
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(diastolicPressure output: BloodPressureModel) {
        self.name = .diastolicPressure
        self.deviceId = output.deviceID
        self.unit = output.bloodPressureMeasurementUnit
        self.measurementDate = output.timeStamp
        self.value = Double(output.diastolicPressureMeasurement)
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(systolicPressure output: BloodPressureModel) {
        self.name = .systolicPressure
        self.deviceId = output.deviceID
        self.unit = output.bloodPressureMeasurementUnit
        self.measurementDate = output.timeStamp
        self.value = Double(output.systolicPressureMeasurement)
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(mpaPressure output: BloodPressureModel) {
        self.name = .mpaPressure
        self.deviceId = output.deviceID
        self.unit = output.bloodPressureMeasurementUnit
        self.measurementDate = output.timeStamp
        self.value = Double(output.mpaPressureMeasurement)
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(pulseRateBloodPressure output: BloodPressureModel) {
        self.name = .pulseRate
        self.deviceId = output.deviceID
        self.unit = .beatsPerMinute
        self.measurementDate = output.timeStamp
        self.value = Double(output.pulseRate)
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(heartRate output: HeartRateModel) {
        self.name = .heartRate
        self.deviceId = output.deviceID
        self.unit = output.heartRateMeasurementUnit
        self.value = Double(output.heartRateMeasurement)
        self.measurementDate = Date()
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(oxigenSaturation output: SpotCheckMeasurementModel) {
        self.name = .oxigenSaturation
        self.deviceId = output.deviceID
        self.unit = output.oxigenSaturationUnit
        self.value = Double(output.oxigenSaturation)
        self.measurementDate = output.timeStamp
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(pulseRate output: SpotCheckMeasurementModel) {
        self.name = .pulseRate
        self.deviceId = output.deviceID
        self.unit = output.pulseRateUnit
        self.value = Double(output.pulseRate)
        self.measurementDate = output.timeStamp
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(weight output: WeightMeasurementModel) {
        self.name = .bodyWeight
        self.deviceId = output.deviceID
        self.unit = output.weightUnit
        self.value = round(10 * Double(output.weight)) / 10
        self.measurementDate = output.timeStamp
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(bodyCompositionWeight output: BodyCompositionModel) {
        self.name = .bodyWeight
        self.deviceId = output.deviceID
        self.unit = output.weightUnit
        self.value = round(10 * Double(output.weight)) / 10
        self.measurementDate = output.timeStamp
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(bmi output: WeightMeasurementModel) {
        self.name = .bmi
        self.deviceId = output.deviceID
        self.unit = output.bmiUnit
        self.value = round(10 * Double(output.bmi)) / 10
        self.measurementDate = output.timeStamp
        self.measurementID = output.measurementID
    }
}

extension Measurement {
    init(height output: WeightMeasurementModel) {
        self.name = .height
        self.deviceId = output.deviceID
        self.unit = output.heightUnit
        self.value = round(10 * Double(output.height)) / 10
        self.measurementDate = output.timeStamp
        self.measurementID = output.measurementID
    }
}
