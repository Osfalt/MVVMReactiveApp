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

    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private(set) lazy var privateContext: NSManagedObjectContext = {
        let privateContext = persistentContainer.newBackgroundContext()
        privateContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        privateContext.automaticallyMergesChangesFromParent = true
        return privateContext
    }()

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
    func object<T: PersistentConvertible>(byPrimaryKey key: StorageKey) -> T? {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(key.name) == %d", key.value)

        let managedObjects = try? mainContext.fetch(fetchRequest)
        let objects = managedObjects?.map(T.init(managedObject:))

        return objects?.first
    }

    func objects<T: PersistentConvertible>(byKey key: StorageKey, sorting: NSSortDescriptor...) -> [T] {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(key.name) == %d", key.value)
        fetchRequest.sortDescriptors = sorting

        let managedObjects = try? mainContext.fetch(fetchRequest)
        let objects = managedObjects?.map(T.init(managedObject:))

        return objects ?? []
    }

    func objects<T: PersistentConvertible>(byKey key: StorageKey,
                                           offset: Int,
                                           limit: Int,
                                           sorting: NSSortDescriptor...) -> [T]
    {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(key.name) == %d", key.value)
        fetchRequest.sortDescriptors = sorting
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit

        let managedObjects = try? mainContext.fetch(fetchRequest)
        let objects = managedObjects?.map(T.init(managedObject:))

        return objects ?? []
    }

    func allObjects<T: PersistentConvertible>(sorting: NSSortDescriptor...) -> [T] {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)
        fetchRequest.sortDescriptors = sorting

        let managedObjects = try? mainContext.fetch(fetchRequest)
        let objects = managedObjects?.map(T.init(managedObject:))

        return objects ?? []
    }

    // MARK: Saving
    func save<T: PersistentConvertible>(object: T) {
        privateContext.perform { [weak self] in
            guard let self = self else { return }
            self.privateContext.insert(object.toManagedObject())
            self.savePrivateContext()
        }
    }

    func save<T: PersistentConvertible>(objects: [T]) {
        privateContext.perform { [weak self] in
            guard let self = self else { return }
            objects.forEach { self.privateContext.insert($0.toManagedObject()) }
            self.savePrivateContext()
        }
    }

    // MARK: Deleting
    func delete<T: PersistentConvertible>(object: T) {
        privateContext.perform { [weak self] in
            guard let self = self else { return }
            let entityName = String(describing: T.ManagedObject.self)
            let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "\(object.primaryKey.name) == %d", object.primaryKey.value)

            let managedObjects = try? self.privateContext.fetch(fetchRequest)
            managedObjects?.forEach { self.privateContext.delete($0) }

            self.savePrivateContext()
        }
    }

    func delete<T: PersistentConvertible>(objects: [T]) {
        privateContext.perform { [weak self] in
            guard let self = self else { return }
            let entityName = String(describing: T.ManagedObject.self)
            let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)

            let predicates = objects.map { NSPredicate(format: "\($0.primaryKey.name) == %d", $0.primaryKey.value) }
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

            let managedObjects = try? self.privateContext.fetch(fetchRequest)
            managedObjects?.forEach { self.privateContext.delete($0) }

            self.savePrivateContext()
        }
    }

    func deleteAll<T: PersistentConvertible>(ofType type: T.Type) {
        privateContext.perform { [weak self] in
            guard let self = self else { return }
            let entityName = String(describing: T.ManagedObject.self)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs
            let result = try? self.privateContext.execute(deleteRequest) as? NSBatchDeleteResult

            if let objectIDArray = result?.result as? [NSManagedObjectID] {
                let changes = [NSDeletedObjectsKey: objectIDArray]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.privateContext])
            }

            self.savePrivateContext()
        }
    }

    // MARK: Counting
    func count<T: PersistentConvertible>(ofType type: T.Type) -> Int {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.resultType = NSFetchRequestResultType.countResultType

        let objectsCount = try? mainContext.count(for: fetchRequest)
        return objectsCount ?? 0
    }

    func count<T: PersistentConvertible>(ofType type: T.Type, byKey key: StorageKey) -> Int {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.resultType = NSFetchRequestResultType.countResultType
        fetchRequest.predicate = NSPredicate(format: "\(key.name) == %d", key.value)

        let objectsCount = try? mainContext.count(for: fetchRequest)
        return objectsCount ?? 0
    }

    // MARK: Flush
    func flush() {
        savePrivateContext()
    }

    // MARK: - Private Methods
    private func savePrivateContext() {
        privateContext.perform {
            guard self.privateContext.hasChanges else { return }

            do {
                try self.privateContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
