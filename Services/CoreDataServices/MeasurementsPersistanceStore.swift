//
//  MeasurementsPersistanceStore.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 20/02/2023.
//

import RxSwift
import CoreData
import UIKit

protocol HasMeasurementsPersistanceService {
    var measurementsPersistanceService: MeasurementsPersistanceService { get }
}

protocol MeasurementsPersistanceService {
    func saveNewMeasurement(measurement: Measurement)
    func saveMeasurementsFromBackend(measurements: [Measurement])
    func deleteMeasurement(measurementID: String)
    func deleteMeasurementsFromSelectedDay(measurement: Measurement)
    func deleteMeasurementsFromDeviceFromSelectedDay(measurement: Measurement)
    func fetchAllMeasurements() -> Single<[Measurement]>
    func fetchMeasurementsByDeviceID(id: String) -> Single<[Measurement]>
    func fetchLatestDeviceMeasurementsForEachType(id: String) -> Single<[Measurement]>
    func fetchLatestMeasurementsForEachType() -> Single<[Measurement]>
    func fetchMeasurementsByIdAndName(id: String, name: MeasurementName) -> Single<[Measurement]>
    func fetchMeasurementsByName(name: MeasurementName) -> Single<[Measurement]>
    func fetchMeasurementsByDateNameID(id: String, name: MeasurementName, date: Date) -> Single<[Measurement]>
    func fetchMeasurementsByDateName(name: MeasurementName, date: Date) -> Single<[Measurement]>
    func saveIfNewMeasurement(newMeasurement: Measurement)
    func fetchMeasurementsByType(name: MeasurementName) -> Single<[Measurement]>
    var dataHasChanged: Observable<String> { get }
    func deleteAllMeasurements()
}

final class MeasurementsPersistanceServiceImpl: MeasurementsPersistanceService {
    // MARK: Properties
    
    private let bag = DisposeBag()
    private let coreDataService: CoreDataService
    private let networkingService: NetworkingService
    private let toastMessageService: ToastsMessageService
    private let keychainManager: KeychainManagerService
    private let accessManager: AccessManager
    
    private var context: NSManagedObjectContext {
        coreDataService.persistentContainer.viewContext
    }
    private var dataHasChangedSubject = PublishSubject<String>()
    var dataHasChanged: RxSwift.Observable<String> { return dataHasChangedSubject }
    
    init(coreDataService: CoreDataService,networkingService: NetworkingService ,toastMessageService: ToastsMessageService, keychainManager: KeychainManagerService, accessManager: AccessManager) {
        self.coreDataService = coreDataService
        self.networkingService = networkingService
        self.toastMessageService = toastMessageService
        self.keychainManager = keychainManager
        self.accessManager = accessManager
    }
    
    // MARK: Public Implementation
    
    private func notifyDataHasChanged(id: String) -> Completable {
        return .create { completable in
            self.dataHasChangedSubject.onNext(id)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func saveNewMeasurement(measurement: Measurement) {
        return coreDataService.insertItem(type: PersistedMeasurement.self, context: context)
            .map { newItem -> PersistedMeasurement in
                newItem.fillUpWith(measurement: measurement)
            }
            .asCompletable()
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: measurement.measurementID))
            .andThen(saveMeasurementToBackendIfLoggedIn(measurement: measurement))
            .subscribe()
            .disposed(by: bag)
    }
    
    private func saveMeasurementToBackendIfLoggedIn(measurement: Measurement) -> Completable {
        switch accessManager.userState {
        case .loggedIn:
            return networkingService.execute(request: API.Endpoint.postMeasurements(newMeasurement: measurement, userID: keychainManager.getUserInfo()?.userID ?? -1), decodingFormat: .json)
                .do(onSuccess: { (_: [MeasurementsResponse]) in
                })
                    .asCompletable()
        default:
            return Completable.error(SyncError.unregisteredUser)
        }
    }
    
    func saveMeasurementsFromBackend(measurements: [Measurement]) {
        for measurement in measurements {
            coreDataService.insertItem(type: PersistedMeasurement.self, context: context)
                .map { newItem -> PersistedMeasurement in
                    newItem.fillUpWith(measurement: measurement)
                }
                .asCompletable()
                .andThen(coreDataService.save(context: context))
                .andThen(notifyDataHasChanged(id: measurement.measurementID))
                .subscribe()
                .disposed(by: bag)
        }
    }
    
    func deleteMeasurement(measurementID: String) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedMeasurement.measurementID), measurementID)
        coreDataService.deleteItem(type: PersistedMeasurement.self, predicate: predicate, context: context)
            .andThen(showMeasurementDeletedMessage())
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: measurementID))
            .subscribe()
            .disposed(by: bag)
    }
    
    func deleteAllMeasurements() {
        let predicate = NSPredicate(value: true) // predykat, który pasuje do wszystkich obiektów
        coreDataService.deleteItem(type: PersistedMeasurement.self, predicate: predicate, context: context)
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: ""))
            .subscribe()
            .disposed(by: bag)
    }
    
    func deleteMeasurementsFromSelectedDay(measurement: Measurement) {
        let predicate = NSPredicate(format: "%K >= %@ AND %K <= %@ AND %K == %@", #keyPath(PersistedMeasurement.date), measurement.measurementDate.startOfDay as NSDate, #keyPath(PersistedMeasurement.date), measurement.measurementDate.endOfDay as NSDate, #keyPath(PersistedMeasurement.name), measurement.name.rawValue)
        coreDataService.deleteItem(type: PersistedMeasurement.self, predicate: predicate, context: context)
            .andThen(showMeasurementDeletedMessage())
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: measurement.measurementID))
            .subscribe()
            .disposed(by: bag)
    }
    
    func deleteMeasurementsFromDeviceFromSelectedDay(measurement: Measurement) {
        // swiftlint:disable:next force_unwrapping
        let predicate = NSPredicate(format: "%K >= %@ AND %K <= %@ AND %K == %@ AND %K == %@", #keyPath(PersistedMeasurement.date), measurement.measurementDate.startOfDay as NSDate, #keyPath(PersistedMeasurement.date), measurement.measurementDate.endOfDay as NSDate, #keyPath(PersistedMeasurement.name), measurement.name.rawValue, #keyPath(PersistedMeasurement.deviceID), measurement.deviceId!)
        coreDataService.deleteItem(type: PersistedMeasurement.self, predicate: predicate, context: context)
            .andThen(showMeasurementDeletedMessage())
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: measurement.measurementID))
            .subscribe()
            .disposed(by: bag)
    }
    
    private func showMeasurementDeletedMessage() -> Completable {
        return .create { completable in
            self.toastMessageService.showToastMessage(type: .measurementDeleted)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func fetchMeasurements(predicate: NSPredicate) -> Single<[Measurement]> {
        return self.coreDataService.fetchItems(type: PersistedMeasurement.self, predicate: predicate, context: context)
            .map { fetchedResults -> [Measurement] in
                return fetchedResults.map { .init(from: $0) }
            }
    }
    
    func fetchAllMeasurements() -> Single<[Measurement]> {
        let predicate = NSPredicate(value: true)
        return fetchMeasurements(predicate: predicate)
    }
    
    func fetchMeasurementsByDeviceID(id: String) -> Single<[Measurement]> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedMeasurement.deviceID), id)
        return fetchMeasurements(predicate: predicate)
    }
    
    func fetchLatestDeviceMeasurementsForEachType(id: String) -> Single<[Measurement]> {
        fetchMeasurementsByDeviceID(id: id)
            .map { measurements in
                let groupedMeasurements = Dictionary(grouping: measurements, by: { $0.name })
                var latestMeasurements = [Measurement]()
                for (_, measurements) in groupedMeasurements {
                    let sortedMeasurements = measurements.sorted(by: { $0.measurementDate > $1.measurementDate })
                    if let latestMeasurement = sortedMeasurements.first {
                        latestMeasurements.append(latestMeasurement)
                    }
                }
                return latestMeasurements
            }
    }
    
    func fetchLatestMeasurementsForEachType() -> Single<[Measurement]> {
        fetchAllMeasurements()
            .map { measurements in
                let groupedMeasurements = Dictionary(grouping: measurements, by: { $0.name })
                var latestMeasurements = [Measurement]()
                for (_, measurements) in groupedMeasurements {
                    let sortedMeasurements = measurements.sorted(by: { $0.measurementDate > $1.measurementDate })
                    if let latestMeasurement = sortedMeasurements.first {
                        latestMeasurements.append(latestMeasurement)
                    }
                }
                return latestMeasurements
            }
    }
    
    func fetchMeasurementsByIdAndName(id: String, name: MeasurementName) -> Single<[Measurement]> {
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(PersistedMeasurement.deviceID), id, #keyPath(PersistedMeasurement.name), name.rawValue)
        return fetchMeasurements(predicate: predicate)
    }
    
    func fetchMeasurementsByName(name: MeasurementName) -> Single<[Measurement]> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedMeasurement.name), name.rawValue)
        return fetchMeasurements(predicate: predicate)
    }
    
    func saveIfNewMeasurement(newMeasurement: Measurement) {
        guard let deviceID = newMeasurement.deviceId else { return }
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@ AND %K == %@", #keyPath(PersistedMeasurement.deviceID), deviceID, #keyPath(PersistedMeasurement.name), newMeasurement.name.rawValue, #keyPath(PersistedMeasurement.date), newMeasurement.measurementDate as NSDate)
        fetchMeasurements(predicate: predicate)
            .subscribe(onSuccess: { measurements in
                if measurements.count == 0 {
                    self.saveNewMeasurement(measurement: newMeasurement)
                } else {
                }
            })
            .disposed(by: bag)
    }
    
    func fetchMeasurementsByDateNameID(id: String, name: MeasurementName, date: Date) -> Single<[Measurement]> {
        fetchMeasurementsByIdAndName(id: id, name: name)
            .map { measurements in
                let targetDate = date
                let calendar = Calendar.current
                let strippedTargetDate = calendar.startOfDay(for: targetDate)
                let filteredMeasurements = measurements.filter {
                    let strippedDate = calendar.startOfDay(for: $0.measurementDate)
                    return strippedDate == strippedTargetDate
                }
                return filteredMeasurements
            }
    }
    
    func fetchMeasurementsByDateName(name: MeasurementName, date: Date) -> Single<[Measurement]> {
        fetchMeasurementsByName(name: name)
            .map { measurements in
                let targetDate = date
                let calendar = Calendar.current
                let strippedTargetDate = calendar.startOfDay(for: targetDate)
                let filteredMeasurements = measurements.filter {
                    let strippedDate = calendar.startOfDay(for: $0.measurementDate)
                    return strippedDate == strippedTargetDate
                }
                return filteredMeasurements
            }
    }
    
    func fetchMeasurementsByType(name: MeasurementName) -> Single<[Measurement]> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedMeasurement.name), name.rawValue)
        return fetchMeasurements(predicate: predicate)
    }
}
