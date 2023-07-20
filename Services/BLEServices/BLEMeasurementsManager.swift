//
//  BatteryService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 12/02/2023.
//

import Foundation
import CoreBluetooth
import RxSwift

protocol HasBLEMeasurementsManager {
    var bleMeasurementsManager: BLEMeasurementsManager { get }
}

protocol BLEMeasurementsManager {
}

final class BLEMeasurementsManagerImpl: BLEMeasurementsManager {
    // MARK: Properties
    private let bag = DisposeBag()
    private let bluetoothService: BLEService
    private let persistedMeasurementsService: MeasurementsPersistanceService
    private let heartRateService: HeartRateService
    private let bloodPressureService: BloodPressureService
    private let batteryService: BatteryService
    private let bodyCompositionService: BodyCompositionService
    private let healthThermometerService: HealthThermometerService
    private let pulseOximeterService: PulseOximeterService
    private let weightScaleService: WeightScaleService
    private let networkingService: NetworkingService
    private let keychainManager: KeychainManagerService

    init(bluetoothService: BLEService, measurementService: MeasurementsPersistanceService, heartRateService: HeartRateService, bloodPressureService: BloodPressureService, batteryService: BatteryService, bodyCompositionService: BodyCompositionService, healthThermometerService: HealthThermometerService, pulseOximeterService: PulseOximeterService, weightScaleService: WeightScaleService, networkingService: NetworkingService, keychainManager: KeychainManagerService) {
        self.bluetoothService = bluetoothService
        self.persistedMeasurementsService = measurementService
        self.batteryService = batteryService
        self.bloodPressureService = bloodPressureService
        self.bodyCompositionService = bodyCompositionService
        self.healthThermometerService = healthThermometerService
        self.heartRateService = heartRateService
        self.pulseOximeterService = pulseOximeterService
        self.weightScaleService = weightScaleService
        self.networkingService = networkingService
        self.keychainManager = keychainManager
        self.startService()
    }
    
    // MARK: Public Implementation
    
    func startService() {
//        fetchAllMeasurements()
        observeBatteryLevel()
        observeBloodPressure()
        observeBodyComposition()
        observeHealthThermometer()
        observeHeartRate()
        observePulseOximeterSpotMeasurement()
        observePulseOximeterPulseRateMeasurement()
        observeWeightScale()
        observeBMI()
        observeHeight()
    }
    
    func fetchAllMeasurements() {
        self.persistedMeasurementsService.fetchAllMeasurements()
            .subscribe { measurements in
                measurements.map { measurement in
                    measurement.map { measure in
                        print(measure)
                    }
                }
            }
            .disposed(by: bag)
    }
    
    func observeBatteryLevel() {
        batteryService.observeBatteryLevel()
            .subscribe(onNext: { batteryLevel in
                print(batteryLevel)
            })
            .disposed(by: bag)
    }
    
    func observeBloodPressure() {
        bloodPressureService.observeBloodPressure()
            .subscribe(onNext: { [weak self] bloodPressure in
                let newDiastolicMeasurement = Measurement(diastolicPressure: bloodPressure)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newDiastolicMeasurement)
                let newSystolicMeasurement = Measurement(systolicPressure: bloodPressure)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newSystolicMeasurement)
                let newMpaMeasurement = Measurement(mpaPressure: bloodPressure)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newMpaMeasurement)
                let newPulseRateMeasurement = Measurement(pulseRateBloodPressure: bloodPressure)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newPulseRateMeasurement)
            })
            .disposed(by: bag)
    }
    
    func observeBodyComposition() {
        bodyCompositionService.observeBodyCompositionMeasurement()
            .subscribe(onNext: { [weak self] bodyComposition in
                let newBodyCompositionMeasurement = Measurement(bodyCompositionWeight: bodyComposition)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newBodyCompositionMeasurement)
            })
            .disposed(by: bag)
    }
    
    func observeHealthThermometer() {
        healthThermometerService.observeTemperatureMeasurement()
            .subscribe(onNext: { [weak self] healthThermometer in
                let newMeasurement = Measurement(bodyTemperature: healthThermometer)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newMeasurement)
            })
            .disposed(by: bag)
    }
    
    func observeHeartRate() {
        heartRateService.observeHeartRateMeasurement()
            .subscribe(onNext: { [weak self] heartRate in
                let newMeasurement = Measurement(heartRate: heartRate)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newMeasurement)
            })
            .disposed(by: bag)
    }
    
    func observePulseOximeterSpotMeasurement() {
        pulseOximeterService.observeSpotCheckMeasurement()
            .subscribe(onNext: { [weak self] spotMeasurement in
                let newMeasurement = Measurement(oxigenSaturation: spotMeasurement)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newMeasurement)
            })
            .disposed(by: bag)
    }
    
    func observePulseOximeterPulseRateMeasurement() {
        pulseOximeterService.observeSpotCheckMeasurement()
            .subscribe(onNext: { [weak self] pulseRate in
                let newMeasurement = Measurement(pulseRate: pulseRate)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newMeasurement)
            })
            .disposed(by: bag)
    }
    
    func observeWeightScale() {
        weightScaleService.observeWeightMeasurement()
            .subscribe(onNext: { [weak self] weightMeasurement in
                let newMeasurement = Measurement(weight: weightMeasurement)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newMeasurement)
            })
            .disposed(by: bag)
    }
    
    func observeBMI() {
        weightScaleService.observeWeightMeasurement()
            .subscribe(onNext: { [weak self] bmi in
                let newMeasurement = Measurement(bmi: bmi)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newMeasurement)
            })
            .disposed(by: bag)
    }
    
    func observeHeight() {
        weightScaleService.observeWeightMeasurement()
            .subscribe(onNext: { [weak self] height in
                let newMeasurement = Measurement(height: height)
                self?.persistedMeasurementsService.saveIfNewMeasurement(newMeasurement: newMeasurement)
            })
            .disposed(by: bag)
    }
}
