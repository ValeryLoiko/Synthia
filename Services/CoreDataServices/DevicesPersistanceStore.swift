//
//  PeripheralDataPersistanceService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 06/02/2023.
//

import RxSwift
import CoreData
import UIKit

protocol HasDevicesPersistanceService {
    var devicesPersistanceService: DevicesPersistanceService { get }
}

protocol DevicesPersistanceService {
    func fetchAllDevices() -> Single<[Device]>
    func saveNewDevice(device: Device)
    func deleteDevice(id: String)
    func updateDeviceName(id: String, newName: String)
    func updateSoleUserChoice(id: String, isMultipleUser: Bool)
    func addDeviceIfNew(device: Device)
    var dataHasChanged: Observable<DeviceID> { get }
    func deleteAllDevices()
}

struct DeviceID: Hashable, Equatable {
    let deviceID: String
    
    init(_ deviceID: String) {
        self.deviceID = deviceID
    }
}

final class DevicesPersistanceServiceImpl: DevicesPersistanceService {
    // MARK: Properties
    
    private let bag = DisposeBag()
    private let coreDataService: CoreDataService
    private let toastMessageService: ToastsMessageService
    private var context: NSManagedObjectContext {
        coreDataService.persistentContainer.viewContext
    }
    private var dataHasChangedSubject = PublishSubject<DeviceID>()
    var dataHasChanged: RxSwift.Observable<DeviceID> { return dataHasChangedSubject }
    
    init(coreDataService: CoreDataService, toastMessageService: ToastsMessageService) {
        self.coreDataService = coreDataService
        self.toastMessageService = toastMessageService
    }
    
    // MARK: Public Implementation
    
    private func notifyDataHasChanged(id: DeviceID) -> Completable {
        return .create { completable in
            self.dataHasChangedSubject.onNext(id)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func fetchAllDevices() -> RxSwift.Single<[Device]> {
        let predicate = NSPredicate(value: true)
        return self.coreDataService.fetchItems(type: PersistedDevice.self, predicate: predicate, context: context)
            .map { fetchedResults -> [Device] in
                return fetchedResults.map { .init(from: $0) }
            }
    }
    
    func fetchDevicesByID(predicate: NSPredicate) -> Single<[Device]> {
        return self.coreDataService.fetchItems(type: PersistedDevice.self, predicate: predicate, context: context)
            .map { fetchedResults -> [Device] in
                return fetchedResults.map { .init(from: $0) }
            }
    }
    
    func saveNewDevice(device: Device) {
        coreDataService.insertItem(type: PersistedDevice.self, context: context)
            .map { newItem -> PersistedDevice in
                newItem.fillUpWith(device: device)
            }
            .asCompletable()
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: DeviceID(device.deviceID)))
            .subscribe()
            .disposed(by: bag)
    }
    
    func deleteDevice(id: String) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedDevice.identifier), id)
        coreDataService.deleteItem(type: PersistedDevice.self, predicate: predicate, context: context)
            .andThen(showDeviceDeletedMessage())
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: DeviceID(id)))
            .subscribe()
            .disposed(by: bag)
    }
    
    func deleteAllDevices() {
        let predicate = NSPredicate(value: true) // predykat, który pasuje do wszystkich obiektów
        coreDataService.deleteItem(type: PersistedDevice.self, predicate: predicate, context: context)
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: DeviceID("")))
            .subscribe()
            .disposed(by: bag)
    }
    
    private func showDeviceDeletedMessage() -> Completable {
        return .create { completable in
            self.toastMessageService.showToastMessage(type: .deviceRemoved)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    private func showAllDataDeleteMessage() -> Completable {
        return .create { completable in
            self.toastMessageService.showToastMessage(type: .removeAllData)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func updateDeviceName(id: String, newName: String) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedDevice.identifier), id)
        self.coreDataService.fetchItems(type: PersistedDevice.self, predicate: predicate, context: context)
            .map { fetchedResults -> [PersistedDevice] in
                fetchedResults.map { peripheral in
                    peripheral.name = newName
                    self.toastMessageService.showToastMessage(type: .nameSaved)
                    return peripheral
                }
                return fetchedResults
            }
            .asCompletable()
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: DeviceID(id)))
            .subscribe()
            .disposed(by: bag)
    }
    
    func updateSoleUserChoice(id: String, isMultipleUser: Bool) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedDevice.identifier), id)
        self.coreDataService.fetchItems(type: PersistedDevice.self, predicate: predicate, context: context)
            .map { fetchedResults -> [PersistedDevice] in
                fetchedResults.map { peripheral in
                    peripheral.soleUser = !isMultipleUser
                    return peripheral
                }
                return fetchedResults
            }
            .asCompletable()
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: DeviceID(id)))
            .subscribe()
            .disposed(by: bag)
    }
    
    func addDeviceIfNew(device: Device) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedDevice.identifier), device.deviceID)
        fetchDevicesByID(predicate: predicate)
            .subscribe(onSuccess: { devices in
                if devices.count == 0 {
                    self.saveNewDevice(device: device)
                    self.toastMessageService.showToastMessage(type: .deviceAdded)
                }
            })
            .disposed(by: bag)
    }
}
