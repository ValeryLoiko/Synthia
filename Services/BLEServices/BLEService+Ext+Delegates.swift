//
//  BLEDelegateManager.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 16/02/2023.
//

import Foundation
import RxSwift
import CoreBluetooth

extension BLEServiceImpl: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        stateSubject.onNext(central.state)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        discoveredPeripheralArray.append(peripheral)
        discoveredPeripheralSubject.onNext(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        didConnectSubject.onNext(peripheral)
        discoverServices(peripheral: peripheral)
        print("Connected to \(peripheral)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let index = connectedPeripheralArray.firstIndex(of: peripheral) {
            connectedPeripheralArray.remove(at: index)
        }
        connectedPeripheralSubject.onNext(connectedPeripheralArray)
        print("Disconnected from \(peripheral)")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        connectedPeripheralArray.append(peripheral)
        connectedPeripheralSubject.onNext(connectedPeripheralArray)
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            } else if characteristic.properties.contains(.indicate) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
            switch characteristic.uuid {
            case Constants.DeviceInformationService.manufacturerNameCBUUID:
                peripheral.readValue(for: characteristic)
            case Constants.DeviceInformationService.serialNumberCBUUID:
                peripheral.readValue(for: characteristic)
            case Constants.DeviceInformationService.modelCBUUID:
                peripheral.readValue(for: characteristic)
            case Constants.DeviceInformationService.firmwareCBUUID:
                peripheral.readValue(for: characteristic)
            case Constants.DeviceInformationService.batteryLevelCBUUID:
                peripheral.readValue(for: characteristic)
            default:
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error { return }
        if characteristic.properties.contains(.notify) {
            characteristicsSubject.onNext((characteristic.uuid, characteristic.value, peripheral.identifier.uuidString))
            peripheral.setNotifyValue(true, for: characteristic)
            
            if characteristic.uuid == Constants.DeviceInformationService.batteryLevelCBUUID {
                if let batteryData = characteristic.value {
                    let batteryLevel = Int(batteryData.first ?? 0)
                    print("Battery Level: \(batteryLevel)%")
                }
            }
        } else if characteristic.properties.contains(.indicate) {
            characteristicsSubject.onNext((characteristic.uuid, characteristic.value, peripheral.identifier.uuidString))
            peripheral.setNotifyValue(true, for: characteristic)
        } else if characteristic.properties.contains(.read) {
            switch characteristic.uuid {
            case Constants.DeviceInformationService.manufacturerNameCBUUID:
                if let manufacturerName = String(data: characteristic.value ?? Data(), encoding: .utf8) {
                    manufacturerNameSubject.onNext(manufacturerName)
                }
            case Constants.DeviceInformationService.serialNumberCBUUID:
                if let serialNumber = String(data: characteristic.value ?? Data(), encoding: .utf8) {
                    serialNumberSubject.onNext(serialNumber)
                }
            case Constants.DeviceInformationService.modelCBUUID:
                if let model = String(data: characteristic.value ?? Data(), encoding: .utf8) {
                    modelNumberSubject.onNext(model)
                }
            case Constants.DeviceInformationService.firmwareCBUUID:
                if let firmware = String(data: characteristic.value ?? Data(), encoding: .utf8) {
                    firmwareSubject.onNext(firmware)
                }
            case Constants.DeviceInformationService.batteryLevelCBUUID:
                if let batteryData = characteristic.value {
                    let batteryLevel = Int(batteryData.first ?? 0)
                    print("Battery Level: \(batteryLevel)%")
                }
            default:
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        discoverServices(peripheral: peripheral)
    }
}
