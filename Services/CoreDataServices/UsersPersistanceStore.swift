//
//  UsersPersistanceStore.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 08/03/2023.
//

import RxSwift
import CoreData
import UIKit

protocol HasUsersPersistanceService {
    var usersPersistanceService: UsersPersistanceService { get }
}

protocol UsersPersistanceService {
    var dataHasChanged: Observable<UserID> { get }
    func fetchAllUsers() -> RxSwift.Single<[User]>
    func fetchUsersByID(predicate: NSPredicate) -> Single<[User]>
    func saveNewUser(user: User)
    func deleteUser(id: String)
    func updateUserName(id: String, userName: String)
    func updateUserSex(id: String, userSex: String)
    func updateUserAge(id: String, userAge: Int)
    func updateUserHeight(id: String, userHeight: Int)
    func updateUserWeight(id: String, userWeight: Int)
    func checkIfNewUser(user: User)
}

struct UserID: Hashable, Equatable {
    let userID: String
    
    init(_ userID: String) {
        self.userID = userID
    }
}

final class UsersPersistanceServiceImpl: UsersPersistanceService {
    // MARK: Properties
    
    private let bag = DisposeBag()
    private let coreDataService: CoreDataService
    private var context: NSManagedObjectContext {
        coreDataService.persistentContainer.viewContext
    }
    private var dataHasChangedSubject = PublishSubject<UserID>()
    var dataHasChanged: RxSwift.Observable<UserID> { return dataHasChangedSubject }
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    // MARK: Public Implementation
    
    private func notifyDataHasChanged(id: UserID) -> Completable {
        return .create { completable in
            self.dataHasChangedSubject.onNext(id)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func fetchAllUsers() -> RxSwift.Single<[User]> {
        let predicate = NSPredicate(value: true)
        return self.coreDataService.fetchItems(type: PersistedUser.self, predicate: predicate, context: context)
            .map { fetchedResults -> [User] in
                return fetchedResults.map { .init(from: $0) }
            }
    }
    
    func fetchUsersByID(predicate: NSPredicate) -> Single<[User]> {
        return self.coreDataService.fetchItems(type: PersistedUser.self, predicate: predicate, context: context)
            .map { fetchedResults -> [User] in
                return fetchedResults.map { .init(from: $0) }
            }
    }

    func saveNewUser(user: User) {
        coreDataService.insertItem(type: PersistedUser.self, context: context)
            .map { newItem -> PersistedUser in
                newItem.fillUpWith(user: user)
            }
            .asCompletable()
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: UserID(user.userID)))
            .subscribe()
            .disposed(by: bag)
    }
    
    func deleteUser(id: String) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedUser.userID), id)
        coreDataService.deleteItem(type: PersistedUser.self, predicate: predicate, context: context)
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: UserID(id)))
            .subscribe()
            .disposed(by: bag)
    }
    
    func updateUserName(id: String, userName: String) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedUser.userID), id)
        self.coreDataService.fetchItems(type: PersistedUser.self, predicate: predicate, context: context)
            .map { fetchedResults -> [PersistedUser] in
                fetchedResults.map { user in
                    user.firstName = userName
                    return user
                }
                return fetchedResults
            }
            .asCompletable()
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: UserID(id)))
            .subscribe()
            .disposed(by: bag)
    }
    
    func updateUserSex(id: String, userSex: String) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedUser.userID), id)
        self.coreDataService.fetchItems(type: PersistedUser.self, predicate: predicate, context: context)
            .map { fetchedResults -> [PersistedUser] in
                fetchedResults.map { user in
                    user.sex = userSex
                    return user
                }
                return fetchedResults
            }
            .asCompletable()
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: UserID(id)))
            .subscribe()
            .disposed(by: bag)
    }
    
    func updateUserAge(id: String, userAge: Int) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedUser.userID), id)
        self.coreDataService.fetchItems(type: PersistedUser.self, predicate: predicate, context: context)
            .map { fetchedResults -> [PersistedUser] in
                fetchedResults.map { user in
                    user.age = Decimal(userAge) as NSDecimalNumber?
                    return user
                }
                return fetchedResults
            }
            .asCompletable()
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: UserID(id)))
            .subscribe()
            .disposed(by: bag)
    }
    
    func updateUserHeight(id: String, userHeight: Int) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedUser.userID), id)
        self.coreDataService.fetchItems(type: PersistedUser.self, predicate: predicate, context: context)
            .map { fetchedResults -> [PersistedUser] in
                fetchedResults.map { user in
                    user.height = Decimal(userHeight) as NSDecimalNumber?
                    return user
                }
                return fetchedResults
            }
            .asCompletable()
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: UserID(id)))
            .subscribe()
            .disposed(by: bag)
    }
    
    func updateUserWeight(id: String, userWeight: Int) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedUser.userID), id)
        self.coreDataService.fetchItems(type: PersistedUser.self, predicate: predicate, context: context)
            .map { fetchedResults -> [PersistedUser] in
                fetchedResults.map { user in
                    user.weight = Decimal(userWeight) as NSDecimalNumber?
                    return user
                }
                return fetchedResults
            }
            .asCompletable()
            .andThen(coreDataService.save(context: context))
            .andThen(notifyDataHasChanged(id: UserID(id)))
            .subscribe()
            .disposed(by: bag)
    }

    func checkIfNewUser(user: User) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(PersistedUser.userID), user.userID)
        fetchUsersByID(predicate: predicate)
            .subscribe(onSuccess: { users in
                if users.count == 0 {
                    self.saveNewUser(user: user)
                }
            })
            .disposed(by: bag)
    }
}
