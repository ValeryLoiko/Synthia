//
//  DatabaseService.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 07/12/2022.
//

import UIKit
import CoreData
import RxSwift

protocol HasCoreDataService {
    var coreDataService: CoreDataService { get }
}

protocol CoreDataService {
    var persistentContainer: NSPersistentContainer { get }
    func save(context: NSManagedObjectContext) -> Completable
    func fetchItems<T: NSManagedObject>(type: T.Type, predicate: NSPredicate, context: NSManagedObjectContext) -> Single<[T]>
    func insertItem<T: NSManagedObject>(type: T.Type, context: NSManagedObjectContext) -> Single<T>
    func deleteItem<T: NSManagedObject>(type: T.Type, predicate: NSPredicate, context: NSManagedObjectContext) -> Completable
}

final class CoreDataServiceImpl: CoreDataService {
    // MARK: Properties
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CDModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: Public Implementation
    
    func save(context: NSManagedObjectContext) -> Completable {
        return Completable.create { completable in
            context.perform {
                guard context.hasChanges else {
                    completable(.completed)
                    return
                }
                do {
                    try context.save()
                    completable(.completed)
                } catch {
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteItem<T: NSManagedObject>(type: T.Type, predicate: NSPredicate, context: NSManagedObjectContext) -> Completable {
        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
        fetchRequest.predicate = predicate
        return Completable.create { completable in
            context.perform {
                var foundItems = [T]()
                do {
                    foundItems = try context.fetch(fetchRequest)
                } catch {
                    completable(.error(error))
                }
                for item in foundItems {
                    context.delete(item)
                }
                completable(.completed)
            }
            return Disposables.create()
        }
    }
    
    func fetchItems<T: NSManagedObject>(type: T.Type, predicate: NSPredicate, context: NSManagedObjectContext) -> Single<[T]> {
        return Single<[T]>.create { single in
            let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
            fetchRequest.predicate = predicate
            context.perform {
                do {
                    let foundItems = try context.fetch(fetchRequest)
                    single(.success(foundItems))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func insertItem<T: NSManagedObject>(type: T.Type, context: NSManagedObjectContext) -> Single<T> {
        return Single.create { single in
            context.perform {
//            swiftlint:disable:next force_cast
                let object = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: context) as! T
                single(.success(object))
            }
            return Disposables.create()
        }
    }
}
