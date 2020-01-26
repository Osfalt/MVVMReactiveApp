//
//  CoreDataStorage.swift
//  PersistentStorageKit
//
//  Created by Dre on 26.01.2020.
//

import Foundation
import CoreData

final class CoreDataStorage: PersistentStorage {

    // MARK: - Constants
    private enum PersistentStore {
        static let name = "MVVMReactiveApp"
    }

    // MARK: Internal Properties
    static let shared = CoreDataStorage()

    var defaultContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Private Properties
    private lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.persistentStorageKit.url(forResource: PersistentStore.name, withExtension: "momd") else {
            preconditionFailure("There is no momd file in the bundle")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            preconditionFailure("Can't load momd file from URL: \(modelURL)")
        }
        let container = NSPersistentContainer(name: PersistentStore.name, managedObjectModel: model)

        container.loadPersistentStores { storeDescription, error in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }

        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.automaticallyMergesChangesFromParent = true

        return container
    }()

    // MARK: - PersistentStorage Protocol
    // MARK: Configure
    func configure() {
        _ = persistentContainer
    }

    // MARK: Fetching
    func objects<T: PersistentConvertible>() -> [T] {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)
        let managedObjects = try? defaultContext.fetch(fetchRequest)
        let objects = managedObjects?.map(T.init(object:))
        return objects ?? []
    }

    func object<T: PersistentConvertible>(byPrimaryKey key: AnyHashable) -> T? {
        return nil
    }

    // MARK: Saving
    func save<T: PersistentConvertible>(object: T) {
        let managedObject = object.toManagedObject()
        defaultContext.insert(managedObject)
    }

    func save<T: PersistentConvertible>(objects: [T]) {

    }

    // MARK: Flush
    func flush() {
        saveContext()
    }

    // MARK: - Private Methods
    private func saveContext() {
        guard defaultContext.hasChanges else { return }

        do {
            try defaultContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

}
