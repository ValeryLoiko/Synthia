//
//  BluetoothService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 08/02/2023.
//

import Foundation
import CoreBluetooth
import RxSwift

protocol HasBLEService {
    var bleService: BLEService { get }
}

protocol BLEService {
    func turnOnCentralManager()
    var stateObservable: Observable<CBManagerState> { get }
    var discoveredPeripheralObservable: Observable<CBPeripheral> { get }
    var discoveredDevicesObservable: Observable<[CBPeripheral]> { get }
    var isScanningObservable: Observable<Bool> { get }
    func startScanning()
    func stopScanning()
    func connect(peripheral: CBPeripheral)
    func disconnect(peripheral: CBPeripheral)
    func disconnectDevice(identifier: UUID)
    func autoReconnect(identifier: UUID) -> Completable
    func retrieveConnection(identifier: UUID)
    var connectedPeripheralObservable: Observable<[CBPeripheral]> { get}
    func observeCharacteristics(uuid: CBUUID) -> RxSwift.Observable<(Data?, String)>
    var manufacturerNameObservable: Observable<String> { get }
    var serialNumberObservable: Observable<String> { get }
    var modelNumberObservable: Observable<String> { get }
    var firmwareObservable: Observable<String> { get }
}

final class BLEServiceImpl: NSObject, BLEService {
    // MARK: Properties
    
    let bag = DisposeBag()
    var centralManager: CBCentralManager?
    var stateSubject = BehaviorSubject<CBManagerState>(value: .unknown)
    var stateObservable: RxSwift.Observable<CBManagerState> { return stateSubject }
    var discoveredPeripheralSubject = PublishSubject<CBPeripheral>()
    var discoveredPeripheralObservable: RxSwift.Observable<CBPeripheral> { return discoveredPeripheralSubject }
    var discoveredDevicesSubject = PublishSubject<[CBPeripheral]>()
    var discoveredDevicesObservable: Observable<[CBPeripheral]> { return discoveredDevicesSubject }
    var didConnectSubject = PublishSubject<CBPeripheral>()
    private var didConnectObservable: Observable<CBPeripheral> { return didConnectSubject }
    var manufacturerNameSubject = PublishSubject<String>()
    var manufacturerNameObservable: Observable<String> { return manufacturerNameSubject }
    var serialNumberSubject = PublishSubject<String>()
    var serialNumberObservable: RxSwift.Observable<String> { return serialNumberSubject }
    var modelNumberSubject = PublishSubject<String>()
    var modelNumberObservable: RxSwift.Observable<String> { return modelNumberSubject }
    var firmwareSubject = PublishSubject<String>()
    var firmwareObservable: RxSwift.Observable<String> { return firmwareSubject }
    
    var isScanningSubject = PublishSubject<Bool>()
    var isScanningObservable: Observable<Bool> { return isScanningSubject }
    var connectedPeripheralArray = [CBPeripheral]()
    var connectedPeripheralSubject = PublishSubject<[CBPeripheral]>()
    var connectedPeripheralObservable: Observable<[CBPeripheral]> { return connectedPeripheralSubject }
    var characteristicsSubject = PublishSubject<(CBUUID, Data?, String)>()
    var discoveredPeripheralArray = [CBPeripheral]() // for keeping strong reference
    func observeCharacteristics(uuid: CBUUID) -> RxSwift.Observable<(Data?, String)> {
        return characteristicsSubject.filter { $0.0 == uuid }
            .map { ($0.1, $0.2) }
    }
    var connectedDeviceSubject = PublishSubject<(CBUUID, String)>()
    func observeConnectedDevices(uuuid: CBUUID, name: String) -> RxSwift.Observable<(CBUUID, String)> {
        return connectedDeviceSubject
    }
    
    private let desiredServices = [Constants.Services.deviceInformationCBUUID, Constants.Services.heartRateServiceCBUUID, Constants.Services.bloodPressureServiceCBUUID, Constants.Services.pulseOximeterServiceCBUUID, Constants.Services.weightScaleServiceCBUUID, Constants.Services.healthThermometerServiceCBUUID, Constants.Services.batteryServiceCBUUID]
    
    enum Constants {
        enum Services: CaseIterable {
            static let deviceInformationCBUUID = CBUUID(string: "0x180A")
            static let heartRateServiceCBUUID = CBUUID(string: "0x180D")
            static let bloodPressureServiceCBUUID = CBUUID(string: "0x1810")
            static let pulseOximeterServiceCBUUID = CBUUID(string: "0x1822")
            static let weightScaleServiceCBUUID = CBUUID(string: "0x181D")
            static let healthThermometerServiceCBUUID = CBUUID(string: "0x1809")
            static let batteryServiceCBUUID = CBUUID(string: "0x180F")
            static let bodyCompositionService = CBUUID(string: "0x181B")
        }
        
        enum DeviceInformationService {
            static let manufacturerNameCBUUID = CBUUID(string: "2A29")
            static let serialNumberCBUUID = CBUUID(string: "2A25")
            static let modelCBUUID = CBUUID(string: "2A24")
            static let firmwareCBUUID = CBUUID(string: "2A26")
            static let batteryLevelCBUUID = CBUUID(string: "2A19")
        }
    }
    
    // MARK: Public Implementation
    func turnOnCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func startScanning() {
        guard let centralManager = self.centralManager else { return }
        centralManager.scanForPeripherals(withServices: desiredServices)
        self.isScanningSubject.onNext(true)
    }
    
    func stopScanning() {
        guard let centralManager = self.centralManager else {
            return
        }
        centralManager.stopScan()
        self.isScanningSubject.onNext(false)
    }
    
    func connect(peripheral: CBPeripheral) {
        guard let centralManager = centralManager else { return }
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnectDevice(identifier: UUID) {
        var uuidArray: [UUID] = []
        uuidArray.append(identifier)
        guard let retrievedPeripherals = centralManager?.retrievePeripherals(withIdentifiers: uuidArray) else { return }
        guard let peripheral = retrievedPeripherals.first else { return }
        centralManager?.cancelPeripheralConnection(peripheral)
    }
    
    func disconnect(peripheral: CBPeripheral) {
        guard let centralManager = centralManager else { return }
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    private var retrievedPeripheralArray: [CBPeripheral] = [] // for keeping strong reference
    func autoReconnect(identifier: UUID) -> Completable {
        var uuidArray: [UUID] = []
        uuidArray.append(identifier)
        guard let retrievedPeripheral = centralManager?.retrievePeripherals(withIdentifiers: uuidArray).first else {
            return Completable.error(BluetoothError.couldntRetrieveDeviceError)
        }
        retrievedPeripheralArray.append(retrievedPeripheral)
        return didConnectObservable.do(onSubscribe: {
            self.connect(peripheral: retrievedPeripheral)
        }).filter { peripheral in
            peripheral.identifier == identifier
        }
        .take(1)
        .asSingle()
        .asCompletable()
    }
    
    private var retrievedPeripheralsArray2: [CBPeripheral] = [] // for keeping strong reference
    func retrieveConnection(identifier: UUID) {
        var uuidArray: [UUID] = []
        uuidArray.append(identifier)
        guard let retrievedPeripherals = centralManager?.retrievePeripherals(withIdentifiers: uuidArray) else { return }
        retrievedPeripheralsArray2 = retrievedPeripherals
        retrievedPeripheralsArray2.forEach({ peripheral in
            print("Retrieving connection to \(peripheral)")
            connect(peripheral: peripheral)
        })
    }
    
    func discoverServices(peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
}
